require 'peddler'
require 'rexml/document'
require 'nokogiri'
require 'csv'

client = MWS::Reports::Client.new(
  "marketplace": "JP",
  "aws_access_key_id": 'AKIAJBEKYRCWPPKUSO4Q',
  "aws_secret_access_key": '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',
  "merchant_id": 'AV7J096OCMDWI'
)

report_type=[
    "_GET_FLAT_FILE_OPEN_LISTINGS_DATA_",
    "_GET_MERCHANT_LISTINGS_DATA_",
    "_GET_FLAT_FILE_ALL_ORDERS_DATA_BY_ORDER_DATE_",
    "_GET_AFN_INVENTORY_DATA_"
]

file_name = [
    "/Users/nakao107/ruby/AmazonReportDownloadTools/data.txt",
    "/Users/nakao107/ruby/AmazonReportDownloadTools/data詳細.txt",
    "/Users/nakao107/ruby/AmazonReportDownloadTools/data売上.txt",
    "/Users/nakao107/ruby/AmazonReportDownloadTools/FBA在庫.txt"
]


report_type.each_with_index do |report_type,i|

    res = client.get_report_list(report_type_list: [report_type])

    report_info = res.parse["ReportInfo"]


    if report_info.kind_of?(Array) #複数あった場合

        report_id = report_info[0]["ReportId"]

    elsif report_info.kind_of?(Hash) #単独の場合

        report_id = report_info["ReportId"]
    
    else #そもそもデータがない場合

        p "#{report_type} not found"
        next

    end

    res = client.get_report(report_id).parse

    File.open(file_name[i],'w') do |file|
        file << res
        p "#{file_name[i]} write complete"
    end
    
end