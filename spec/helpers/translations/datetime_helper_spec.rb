require "rails_helper"

RSpec.describe Translations::DatetimeHelper, type: :helper do
  let(:date) { Time.zone.local(2026, 4, 17, 10, 30) }

  describe "#translate_month_name" do
    it "returns month name from translated month list" do
      allow(helper).to receive(:translate_date).with("month_names").and_return([ nil, "Jan", "Fev", "Mar", "Abr" ])

      expect(helper.translate_month_name(4)).to eq("Abr")
    end
  end

  describe "#translate_day_week_name" do
    it "returns weekday name from translated day list using one-based input" do
      allow(helper).to receive(:translate_date).with("day_names").and_return(%w[Dom Seg Ter Qua Qui Sex Sab])

      expect(helper.translate_day_week_name(3)).to eq("Ter")
    end
  end

  describe "#translate_date_format" do
    it "returns empty string when date is blank" do
      expect(helper.translate_date_format("default", nil)).to eq("")
    end
  end

  describe "#translate_date_format_long" do
    it "passes translated month name to date formatter" do
      allow(helper).to receive(:translate_month_name).with(date.mon).and_return("Abr")
      expect(helper).to receive(:translate_date_format) do |path, dt, params|
        expect(path).to eq("long")
        expect(dt).to eq(date)
        expect(params).to eq({ month_name: "Abr" })
        "17 de Abr"
      end

      expect(helper.translate_date_format_long(date)).to eq("17 de Abr")
    end
  end

  describe "#translate_date_format_long_week" do
    it "passes translated weekday and month names to date formatter" do
      allow(helper).to receive(:translate_day_week_name).with(date.wday).and_return("Sex")
      allow(helper).to receive(:translate_month_name).with(date.mon).and_return("Abr")
      expect(helper).to receive(:translate_date_format) do |path, dt, params|
        expect(path).to eq("longw")
        expect(dt).to eq(date)
        expect(params).to eq({ week_name: "Sex", month_name: "Abr" })
        "Sex, 17 de Abr"
      end

      expect(helper.translate_date_format_long_week(date)).to eq("Sex, 17 de Abr")
    end
  end

  describe "#translate_date_format_short" do
    it "passes translated month name to short formatter" do
      allow(helper).to receive(:translate_month_name).with(date.mon).and_return("Abr")
      expect(helper).to receive(:translate_date_format) do |path, dt, params|
        expect(path).to eq("short")
        expect(dt).to eq(date)
        expect(params).to eq({ month_name: "Abr" })
        "17 Abr"
      end

      expect(helper.translate_date_format_short(date)).to eq("17 Abr")
    end
  end

  describe "#translate_datetime_format_default" do
    it "returns empty string when date is blank" do
      expect(helper.translate_datetime_format_default(nil, "dt_at")).to eq("")
    end
  end

  describe "#translate_datetime_format_long" do
    it "builds formatted payload when date is present and returns method result" do
      allow(helper).to receive(:translate_date_format_long).with(date).and_return("17 de Abr")
      allow(helper).to receive(:translate_hour).with(date).and_return("10:30")
      expect(helper).to receive(:translate_time_format) do |path, params|
        expect(path).to eq("dt_at")
        expect(params).to eq({ date: "17 de Abr", time: "10:30" })
        "17 de Abr às 10:30"
      end

      expect(helper.translate_datetime_format_long(date, "dt_at")).to eq("")
    end
  end

  describe "#translate_datetime_format_long_week" do
    it "builds formatted payload when date is present and returns method result" do
      allow(helper).to receive(:translate_date_format_long_week).with(date).and_return("Sex, 17 de Abr")
      allow(helper).to receive(:translate_hour).with(date).and_return("10:30")
      expect(helper).to receive(:translate_time_format) do |path, params|
        expect(path).to eq("dt_at")
        expect(params).to eq({ date: "Sex, 17 de Abr", time: "10:30" })
        "Sex, 17 de Abr às 10:30"
      end

      expect(helper.translate_datetime_format_long_week(date, "dt_at")).to eq("")
    end
  end
end
