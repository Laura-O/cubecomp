require 'test_helper'

class DayRegistrationTest < ActiveSupport::TestCase
  setup do
    @registration = day_registrations(:flo_aachen_open_day_one)
  end

  test 'validates presence and integrity of competition' do
    @registration.competition = nil
    assert_not_valid(@registration, :competition)

    @registration.competition_id = 17
    assert_not_valid(@registration, :competition)
  end

  test 'validates presence and integrity of day' do
    @registration.day = nil
    assert_not_valid(@registration, :day)

    @registration.day_id = 17
    assert_not_valid(@registration, :day)
  end

  test 'validates presence and integrity of competitor' do
    @registration.competitor = nil
    assert_not_valid(@registration, :competitor)

    @registration.competitor_id = 17
    assert_not_valid(@registration, :competitor)
  end

  test 'validates uniqueness of competitor scoped by day' do
    new_registration = @registration.dup
    assert_not_valid(new_registration, :competitor_id)

    new_registration.day = days(:aachen_open_day_two)
    assert_valid(new_registration)
  end

  test 'validates integrity of competition ids' do
    @registration.competition = competitions(:german_open)
    assert_not_valid(@registration, :competition_id)
    errors = @registration.errors[:competition_id]
    assert_equal ['does not match day competition_id', 'does not match competitor competition_id'], errors
  end

  test "destroying a competitor's registration for a day destroys their registrations for events on that day" do
    count = @registration.competitor.event_registrations.on_day(@registration.day).count
    assert_difference 'EventRegistration.count', -1 * count do
      assert_no_difference 'Day.count' do
        assert_no_difference 'Event.count' do
          @registration.destroy
        end
      end
    end
    assert_equal [], @registration.competitor.events.select{ |event| event.day == @registration.day }
  end
end
