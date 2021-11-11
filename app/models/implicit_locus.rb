class ImplicitLocus
	attr_accessor :locus_type
	attr_accessor :range
	attr_accessor :mutability

	def initialize
		self.locus_type = available_locus_types.shuffle.first
		autogenerate_range
		self.mutability = 0.0001
	end

	def available_locus_types
		ImplicitLocus.available_locus_types
	end

	def self.available_locus_types
		[
			:binary,
			:discrete,
			:continuous
		]
	end

	def autogenerate_range
		case locus_type
			when :binary
				self.range = 2

			when :discrete
				self.range = (Environment.rnd.rand * 50).to_i
				self.range = 2 if self.range < 2

			when :continuous
				self.range = 1.0
		end
	end

	def generate_value(prev_value = nil)
		case locus_type
			when :binary
				[0, 1].shuffle.first
			when :discrete
				(Environment.rnd.rand * self.range).to_i

			when :continuous
				if prev_value.present?
					(Environment.rnd.rand * 0.25) + prev_value
				else
					Environment.rnd.rand
				end
		end
	end
end
