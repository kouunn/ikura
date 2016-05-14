class Product < ActiveRecord::Base
	attr_accessor :parent_id
	has_and_belongs_to_many :categories
	has_many :images
	accepts_nested_attributes_for :categories, allow_destroy: true
	#上传文件
	mount_uploaders :avatars, AvatarUploader

end
