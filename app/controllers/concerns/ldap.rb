class Ldap

  ATTRIBUTES = %w(cn displayname mail)

  def initialize
    @config = Rails.application.secrets.ldap

    @client = Net::LDAP.new(
      host: @config['host'],
      port: @config['port'],
      verbose: true,
      encryption: { method: :simple_tls },
      auth: {
        method: :simple,
        username: @config['system_username'],
        password: @config['system_password']
      }
    )
  end

  def authenticate(username, password)
    return false if username.empty? || password.empty?

    bind_user = @client.bind_as(
      base: @config['basedn'],
      filter: "cn=#{username}",
      password: password,
      attributes: ATTRIBUTES
    ).first

    # We need to check that cn is the same as username
    # since the AD binds usernames with non-ascii chars
    if bind_user && bind_user.cn.first.downcase == username
      Rails.logger.info "[LDAP_AUTH] #{username} authenticated successfully. #{@client.get_operation_result}"
      bind_user
    else
      Rails.logger.info "[LDAP_AUTH] #{username} failed to log in. #{@client.get_operation_result}"
      false
    end
  end

  def belongs_to_group(username)
    @config['roles'].each do |group|
      # 1.2.840.113556.1.4.1941 is the MS AD way
      filter = (Net::LDAP::Filter.eq('cn', username) &
        Net::LDAP::Filter.ex('memberOf:1.2.840.113556.1.4.1941',
          "CN=#{group['ldap_name']},#{@config['base_group']}"))

      entry = @client.search(base: @config['basedn'], filter: filter).first
      return group['name'] if entry.present?
    end
    false
  end

  # Update user attributes from the ldap user
  def update_user_profile(username)
    # Fetch user attributes
    ldap_user = @client.search(
      base: @config['basedn'],
      filter: "cn=#{username.downcase}",
      attributes: ATTRIBUTES
    ).first

    unless ldap_user.present?
      Rails.logger.info "[LDAP_AUTH]: Couldn't find #{user.username}. #{@client.get_operation_result}"
    end

    begin
      user.username    = username
      user.displayname = ldap_user['displayname'].first
      user.email       = ldap_user['mail'].first

      user.save
      return user
    rescue Exception => e
      Rails.logger.error "[LDAP_AUTH]: Couldn't save user #{user.username}. #{e.message}"
      return false
    end
  end
end
