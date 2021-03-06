require 'test_helper'

class DayTest < ActiveSupport::TestCase
  setup do
    @day = days(:aachen_open_day_one)
  end

  test 'validates presence of competition' do
    @day.competition = nil
    assert_not_valid(@day, :competition)

    @day.competition_id = 1234
    assert_not_valid(@day, :competition)
  end

  test 'validates presence of date' do
    @day.date = nil
    assert_not_valid(@day, :date)
  end

  test 'validates uniqueness of date, but only scoped to competition' do
    another_day = @day.dup
    assert_not_valid(another_day, :date)

    another_day.competition = competitions(:german_open)
    assert_valid another_day
  end

  [ :entrance_fee_competitors, :entrance_fee_guests ].each do |fee|
    test "validates presence of #{fee}" do
      @day.send("#{fee}=", nil)
      assert_not_valid(@day, fee)
    end

    test "validates numericality of #{fee}" do
      @day.send("#{fee}=", 'foobar')
      assert_not_valid(@day, fee)

      @day.send("#{fee}=", 17)
      assert_valid(@day)

      @day.send("#{fee}=", 42.17)
      assert_valid(@day)

      @day.send("#{fee}=", 0)
      assert_valid(@day)

      @day.send("#{fee}=", -10)
      assert_not_valid(@day, fee)
    end
  end

  test 'destroying day destroys all the events of that day' do
    count = @day.events.count
    assert_difference 'Event.count', -1 * count do
      @day.destroy
    end
  end

  test 'destroying day destroys registrations but not competitors' do
    count = @day.registrations.count
    assert_difference 'DayRegistration.count', -1 * count do
      assert_no_difference 'Competitor.count' do
        @day.destroy
      end
    end
  end
end
