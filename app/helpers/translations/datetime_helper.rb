module Translations::DatetimeHelper
    def translate_date(path, params = {})
        t("date.#{path}.", **params)
    end

    def translate_time(path, params = {})
        t("time.#{path}", **params)
    end

    def translate_month_name(month)
        translate_date("month_names")[month]
    end

    def translate_day_week_name(week_day)
        translate_date("day_names")[week_day-1]
    end

    def translate_date_format(path, date, params = {})
        if date.present?
            return date.strftime(translate_date("formats.#{path}.", params))
        end
        ""
    end

    def translate_time_format(path, params = {})
        translate_time("formats.#{path}.", params)
    end

    def translate_hour(date)
        date.strftime(translate_time("hour_format"))
    end

    def translate_date_format_default(date)
        translate_date_format("default", date)
    end

    def translate_date_format_long(date)
        translate_date_format("long", date, {
            month_name: translate_month_name(date.mon)
        })
    end

    def translate_date_format_long_week(date)
        translate_date_format("longw", date, {
            week_name: translate_day_week_name(date.wday),
            month_name: translate_month_name(date.mon)
        })
    end

    def translate_date_format_short(date)
        translate_date_format("short", date, {
            month_name: translate_month_name(date.mon)
        })
    end

    def translate_datetime_format_default(date, dt_type)
        if date.present?
            return translate_time_format("#{dt_type}", {
                date: translate_date_format_default(date),
                time: translate_hour(date)
            })
        end
        ""
    end

    def translate_datetime_format_long(date, dt_type)
        if date.present?
            translate_time_format("#{dt_type}", {
                date: translate_date_format_long(date),
                time: translate_hour(date)
            })
        end
        ""
    end

    def translate_datetime_format_long_week(date, dt_type)
        if date.present?
            translate_time_format("#{dt_type}", {
                date: translate_date_format_long_week(date),
                time: translate_hour(date)
            })
        end
        ""
    end

    alias_method :t_date, :translate_date
    alias_method :t_time, :translate_time
    alias_method :t_month_name, :translate_month_name
    alias_method :t_day_week_name, :translate_day_week_name
    alias_method :t_date_format, :translate_date_format
    alias_method :t_time_format, :translate_time_format
    alias_method :t_hour, :translate_hour
    alias_method :t_date_format_default, :translate_date_format_default
    alias_method :t_date_format_long, :translate_date_format_long
    alias_method :t_date_format_long_week, :translate_date_format_long_week
    alias_method :t_date_format_short, :translate_date_format_short
    alias_method :t_datetime_format_default, :translate_datetime_format_default
    alias_method :t_datetime_format_long, :translate_datetime_format_long
    alias_method :t_datetime_format_long_week, :translate_datetime_format_long_week
end
