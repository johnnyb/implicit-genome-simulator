class Locus
	attr_accessor :implicit_locus
	attr_accessor :value

	def initialize(ilocus, new_value = nil)
		self.implicit_locus = ilocus
		self.value = new_value || self.implicit_locus.generate_value 
	end

	def duplicate
		Locus.new(implicit_locus, value)
	end

	def possibly_mutate!
		mutate! if Environment.rnd.rand < implicit_locus.mutability
	end

	def mutate!
		self.value = implicit_locus.generate_value(value)
	end
end
