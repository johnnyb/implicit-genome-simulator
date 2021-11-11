class ImplicitGenome
	attr_accessor :implicit_loci

	def initialize(num_loci)
		new_loci = []
		1.upto(num_loci) do
			new_loci.push(ImplicitLocus.new)
		end
		self.implicit_loci = new_loci
	end
end
