# Extra kostnader för personer
module Economy
  class PersonExtraCost < Base
    def initialize(person, interval)
      @person = person
      @interval = interval
    end

    def sum
      as_array.compact.sum
    end

    def as_formula
      as_array.join('+')
    end

    def as_array
      @person.person_extra_costs.map do |rec|
        rec if rec.date >= @interval[:from].to_date && rec.date <= @interval[:to].to_date
      end.compact.map(&:amount)
    end
  end
end
