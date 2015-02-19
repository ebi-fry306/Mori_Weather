# coding: utf-8

require 'twitter'
require 'open-uri'
require 'json'

require './oauth.rb'

client = Twitter::REST::Client.new do |config|
	config.consumer_key       	= Consumerkey
	config.consumer_secret    	= Consumersecret
	config.access_token       	= Accesstoken
	config.access_token_secret	= Accesstokensecret
end

#緯度と経度で取得しないと数値が正しくなかったので
api = "http://api.openweathermap.org/data/2.5/weather?lat=34.83&lon=137.93"
source = open(api).read()
json = JSON.parser.new(source)
hash = json.parse()

#今日もいいペンキ☆
weather = hash['weather']
weather_data = weather.first['main']

if weather_data == "Rain"
	#降水量取得
	rain = hash['rain']
	rain_3h = rain['3h']
	weather_data = "雨(降水量" + rain_3h.to_s + "mm)"
elsif weather_data == "Clouds"
	weather_data = "曇り"
elsif weather_data == "Clear"
	weather_data = "晴れ"
else
	weather_data = "不明"
end

#ブォオオオオオオオオ
wind = hash['wind']
speed = wind['speed']
deg = wind['deg']

#適当に判別(鼻ホジ)
if deg < 20
	deg = "北"
elsif deg < 70
	deg = "北東"
elsif deg < 110
	deg = "東"
elsif deg < 160
	deg "南東"
elsif deg < 200
	deg = "南"
elsif deg < 250
	deg < "南西"
elsif deg < 290
	deg = "西"
elsif deg < 340
	deg = "北西"
else
	deg = "北"
end

#温度とか気圧とか湿度とか
main = hash['main']
temp = main['temp'].to_f - 273.15
temp_min = main['temp_min'].to_f - 273.15
temp_max = main['temp_max'].to_f - 273.15
pressure = main['pressure'].to_i
humidity = main['humidity'].to_i

weather_str = "現在の天気は" + weather_data + "\n"
temp_str = "現在の気温は" + "%.1f" % (temp).to_s + "℃\n"
#temp_min_str = "最低気温は" + "%.1f" % (temp_min).to_s + "℃\n"
#temp_max_str = "最高気温は" + "%.1f" % (temp_max).to_s + "℃\n"
humidity_str = "湿度は" + humidity.to_s + "%\n"
pressure_str = "気圧は" + pressure.to_s + "hpa" + "\n"
wind_str = "風速は" + deg + "方向から" + speed.to_s + "m/s\n"

#時間取得
time = Time.new
date = "[#{time.mon}月#{time.day}日#{time.hour}時現在]"

tweet = weather_str + temp_str + humidity_str + pressure_str + wind_str + date

client.update(tweet)
