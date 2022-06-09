require 'net/http'
require 'uri'
require 'json'

class ImportActress
  def self.save_actress
    num = 0
    loop do
      offset = num * 100 + 1

      uri = URI.parse("https://api.dmm.com/affiliate/v3/ActressSearch?api_id=2eFmaKs37peaxDPnzXLp&affiliate_id=eityamo-990&offset=#{offset}&hits=100")
      json = Net::HTTP.get(uri)
      results = JSON.parse(json, { symbolize_names: true })[:result][:actress]
      results.each do |result|
        if result[:name].present? && result[:cup].present? && result[:prefectures].present? && result[:imageURL].present? && result[:imageURL][:large].present? && result[:listURL].present? && result[:listURL][:digital].present?
          if Prefecture.where("name LIKE ?", "#{result[:prefectures]}%").first != nil
            Actress.create(name: result[:name], cup: result[:cup], prefecture: result[:prefectures], image: result[:imageURL][:large], digital: result[:listURL][:digital], prefecture_id: Prefecture.where("name LIKE ?", "#{result[:prefectures]}%").first.id)
          end
        end
      end
      if results.length < 100
        break
      end
      num += 1
    end
  end
end