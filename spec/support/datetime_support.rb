module DateTimeSpecHelper
    def select_datetime(day, month, year, hour, minute)
        find("input[name='meet[start_time]']").click
        while find('.vdatetime-calendar__current--month').text != (month+' '+year)
          find('.vdatetime-calendar__navigation--next').click
        end
        find('.vdatetime-calendar__month__day', text: day).click
        find('.vdatetime-popup__actions__button--confirm').click
        find('.vdatetime-time-picker__list--hours > .vdatetime-time-picker__item', text: hour).click
        find('.vdatetime-time-picker__list--minutes > .vdatetime-time-picker__item', text: minute).click
        find('.vdatetime-popup__actions__button--confirm').click
    end
end
