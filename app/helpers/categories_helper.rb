module CategoriesHelper
	def get_sub_categories(x)
		Category.where(:parent_id => x)
	end
end
