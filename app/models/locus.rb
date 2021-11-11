class Locus
	attr_accessor :implicit_locus
	attr_accessor :value

	def initialize(ilocus)
		self.implicit_locus = ilocus
		self.value = self.implicit_locus.generate_value
	end

	def possibly_mutate!
		mutate! if Environment.rnd.rand < implicit_locus.mutability
	end

	def mutate!
		self.value = implicit_locus.generate_value(value)
	end
end
