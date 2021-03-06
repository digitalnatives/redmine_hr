module HrHolidayCalculator
  module Hun2014

    HrHolidayCalculator.register_module self

    class << self
      attr_reader :year

      def calculate(profile, year = Date.today)
        @year = year
        days = (20 + for_year(profile))
        if profile.employment_date > year.beginning_of_year
          (( days.to_f  / 365 ) * ( year.end_of_year - profile.employment_date ).to_i).round
        else
          days
        end
      end

      def for_year(profile)
        extra_from_age(profile.age) + extra_from_children(profile)
      end

      def extra_from_age(age)
        case age
        when 0..17
          5
        when 18..24
          0
        when 25..27
          1
        when 28..30
          2
        when 31..32
          3
        when 33..34
          4
        when 35..36
          5
        when 37..38
          6
        when 39..40
          7
        when 41..42
          8
        when 43..44
          9
        else 10
        end
      end

      def extra_from_children(profile)
        children = profile.children
        children_count_for_extra = children.select {|child| child.age <= 16 }.length

        extra = case children_count_for_extra
        when 0
          0
        when 1
          2
        when 2
          4
        else 7
        end

        return extra if profile.gender == 'female'

        children_this_year = children.select { |child|
          child.birth_date >= year.beginning_of_year &&
          child.birth_date <= year.end_of_year
         }.length

        extra_year = case children_this_year
        when 0
          0
        when 1
          5
        else 7
        end

        extra + extra_year
      end
    end
  end
end
