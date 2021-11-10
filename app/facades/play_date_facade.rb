class PlayDateFacade
  class << self
    def create_play_date(json)
      PlayDateService.create_play_date(json)
    end

    def find_for_user(id, status = 'all')
      PlayDateService.find_for_user(id, status).map do |pd|
        PlayDatePoro.new(format_data(pd))
      end
    end

    def update_play_date(id, status)
      PlayDateService.update_play_date(id, status)
    end

    def search_by_id(id)
      play_date = PlayDateService.search_by_id(id)
      PlayDatePoro.new(play_date)
    end

    private

    def format_data(data)
      {
        id: data[:id],
        invited_dog_id: data[:relationships][:invited_dog][:data][:id],
        creator_dog_id: data[:relationships][:creator_dog][:data][:id],
        date: data[:attributes][:date],
        time: format_time(data[:attributes][:time]),
        location_id: data[:attributes][:location_id]
      }
    end

    def format_time(time)
      time.scan(/\d\d:\d\d/).first
    end
  end
end
