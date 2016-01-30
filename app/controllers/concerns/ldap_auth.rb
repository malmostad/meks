class LdapAuth
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
      attributes: %w(cn displayname mail)
    )

    # We need to check that cn is the same as username
    # since the AD binds usernames with non-ascii chars
    if bind_user && bind_user.first.cn.first.downcase == username
      Rails.logger.info "LDAP: #{username} authenticated successfully. #{@client.get_operation_result}"
      bind_user.first
    else
      Rails.logger.info "LDAP: #{username} failed to log in. #{@client.get_operation_result}"
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
end
