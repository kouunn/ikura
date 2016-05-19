require 'open-uri'

require 'net/http'


class NokogiriController < ApplicationController


	def index

		#render :text => "xx",layout =>"xx"
		render layout: 'homepage'

	end

	def search
		render layout: 'search_index'
		
	end

	def search_result
			#需要异常处理
			


				@key_word = params[:searchterm]
				
				#汇率 API - json  汇率=rate['showapi_res_body']['money']
				response=Net::HTTP.get_response(URI('http://route.showapi.com/105-31?showapi_appid=18266&showapi_sign=0142ab2f164a43999ddd4fff43ebd063&fromCode=JPY&toCode=CNY&money=100&'))
				@rate = JSON.parse(response.body)


					 		

 				begin #开始
 				 
 				 #Kakaku
 				 	#.encode('Shift-JIS', 'utf-8')#.force_encoding('Shift-JIS')#encode("Shift-JIS")
 				 	# Parse the URI and retrieve it to a temporary file
 				 	kakaku_tmp_file = open("http://kakaku.com/search_results/#{CGI.escape @key_word.encode(Encoding::SJIS)}/")
 				 	# Parse the contents of the temporary file as HTML
 				 	doc = Nokogiri::HTML(kakaku_tmp_file)
 				 	# Define the css selectors to be used for extractions, most
 				 	product_css_class         =".itemInfo"
 				 	#product_header_css_class  ="p.itemnameN"
 				 	product_title_css_class   ="div p"
 				 	product_price_css_class   =".yen"
 				 	product_url_css_class  ='//div[@class="iviewbtn"]/a/@href'
 				 	product_picture_css_class ='//div[@class="itemphoto"]/noscript/a[@class="noscriptLink"]/img/@src'
 				 	# extract all the products 
 				 	k_product = doc.css(product_css_class)
 				 	#extract the title from the products
 				 	#products.each do |product|
 				 	@k_product_title = k_product.css(product_title_css_class).first.text




				    @k_product_price = (k_product.css(product_price_css_class).first.text.gsub(/\D/, '').to_f*@rate['showapi_res_body']['money'].to_f/100).to_i#[/[^〜$\.]+/] 
				    @k_product_url   = k_product.xpath(product_url_css_class).first.text
	 			    @k_product_picture = k_product.xpath(product_picture_css_class).first.text
				 		#搜索关键字：santen-fx neo 有问题 
 				rescue NoMethodError

 					#flash[:notice]="kakaku NoMethodError!"

 				rescue Encoding::UndefinedConversionError
 					
 					redirect_to nokogiri_search_path, alert:"没有找到与 “#{params[:searchterm]}” 相关的产品！"

 				rescue OpenURI::HTTPError
 					
 					redirect_to nokogiri_search_path, notice:"请输入搜素关键字!"	
 				
 				ensure #不管有没有异常，进入该代码块

	 				#Amazon

	 				begin
						amazon_tmp_file = open("http://www.amazon.co.jp/s/field-keywords=#{CGI.escape @key_word}")
		 			    doc = Nokogiri::HTML(amazon_tmp_file)

		 				product_css_class         =".s-item-container"
		 				product_title_css_class   ="a h2"
		 				product_price_css_class   =".s-price"
		 				product_url_css_class     ='//div[@id="atfResults"]/ul/li/div/div/div/div/a/@href'
		 				product_picture_css_class ='//div[@id="atfResults"]/ul/li/div/div/div/div/a/img/@src'
		 				a_product = doc.css(product_css_class)	 		
		 			    @a_product_title = a_product.css(product_title_css_class).first.text
					    @a_product_price = (a_product.css(product_price_css_class).first.text.gsub(/\D/, '').to_f*@rate['showapi_res_body']['money'].to_f/100).to_i
					    @a_product_url   = a_product.xpath(product_url_css_class).first.text
		 			    @a_product_picture = a_product.xpath(product_picture_css_class).first.text				
	 				
 					rescue NoMethodError

 						#flash[:notice]="amazon NoMethodError!"

 					rescue Encoding::UndefinedConversionError
 						
 						redirect_to nokogiri_search_path, alert:"没有找到与 “#{params[:searchterm]}” 相关的产品！"

 					rescue OpenURI::HTTPError
 						
 						redirect_to nokogiri_search_path, notice:"请输入搜素关键字!"
	 			

	 				
	 				ensure

	 					begin
	 						#Rakuten
							rakuten_tmp_file = open("http://search.rakuten.co.jp/search/mall/#{CGI.escape @key_word}")
			 			    doc = Nokogiri::HTML(rakuten_tmp_file)

			 				product_css_class         =".rsrSResultSect"
			 				#product_header_css_class  =".rsrSResultItemTxt"
			 				product_title_css_class   ="h2"
			 				product_price_css_class   ="p a"
			 				product_url_css_class     ="h2 a"#'//div[@class="rsrSResultItemTxt"]/h2/a/@href'
			 				product_picture_css_class ='//div[@class="rsrSResultPhoto"]/a/img/@src'
			 				
			 				r_product = doc.css(product_css_class)
	 							 						@r_product_title =  r_product.css(product_title_css_class).first.text#title_nodes[0].text
	 						@r_product_price =  (r_product.css(product_price_css_class).first.text.gsub(/\D/, '').to_f*@rate['showapi_res_body']['money'].to_f/100).to_i#[/[0-9]+/]
	 						@r_product_picture = r_product.xpath(product_picture_css_class).first.text 					  
	 						@r_product_url   = r_product.css(product_url_css_class).attribute("href").text#[/https?:\/\/[\S]+/]
			 			rescue NoMethodError

			 				#flash[:notice]="rakuten NoMethodError!"


	 					

	 					ensure

	 					end
			 		


		 					

	 				end


	 					 				

				


	  			
	                

	 					
 				 
 				end #结束
 				
 			#rescue 

 				#redirect_to nokogiri_search_path, alert:"没有找到与 “#{params[:searchterm]}” 相关的产品！"

				
			 


			      	
	
			     


 	
 


			#render "search"
			#render :text => html,:layout => true
			#render "nokogiri/search",:text => html

	end

	def logistics_trace
		@key_word = "cd245505083jp"
		post_tmp_file = open("https://trackings.post.japanpost.jp/services/srv/search/?requestNo1=#{CGI.escape @key_word}&search=%E8%BF%BD%E8%B7%A1%E3%82%B9%E3%82%BF%E3%83%BC%E3%83%88")
		 			    doc = Nokogiri::HTML(post_tmp_file)

		 			    		#logistics = doc.css(".m_b5")
		 			    		logistics = doc.css(".w_180")

		 			    		logistics_id_css_class   ="td"
		 			    		@logistics_id =  logistics.css(logistics_id_css_class ).text

		 			    		logistics = doc.css(".w_380")
		 			    		@logistics_type=  logistics.css(logistics_id_css_class ).text

		 			    		logistics = doc.css(".w_120")
		 			    		@logistics_history_time =  logistics.css(logistics_id_css_class ).text


		 			    		@doc=doc
				 				#product_typle_css_class = doc.css(".w_180")	

				 				
				 				#@product = doc.css(".w_180").attribute("th");
		 					    #@product_title =  product.css(product_title_css_class).text#title_nodes[0].text
		 					    #@product_title =  product.css(product_type_css_class).text
		 					    #@product_title =  product.css(product_title_css_class).second.text
		 						#@r_product_price =  (r_product.css(product_price_css_class).first.text.gsub(/\D/, '').to_f*@rate['showapi_res_body']['money'].to_f/100).to_i#[/[0-9]+/]
		 						#@r_product_picture = r_product.xpath(product_picture_css_class).first.text 					  
		 						#@r_product_url   = r_product.css(product_url_css_class).attribute("href").text#[/https?:\/\/[\S]+/]
		
	end



end
