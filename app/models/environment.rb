class Environment
	attr_accessor :implicit_genome
	attr_accessor :fitness_values

	def self.rnd
		@@rnd ||= Random.new
	end

	def initialize(igenome)
		self.implicit_genome = igenome
		fvalues = {}
		igenome.implicit_loci.each do |ilocus|
			min_fitness = Environment.rnd.rand * 1
			max_fitness = Environment.rnd.rand * 3
			if min_fitness > max_fitness
				min_fitness, max_fitness = max_fitness, min_fitness
			end
			optimal_value = ilocus.generate_value
			fvalues[ilocus] = [optimal_value, min_fitness, max_fitness]
		end
		self.fitness_values = fvalues
	end

	def fitness_for_locus(locus)
		ilocus = locus.implicit_locus
		opt_val, min_fit, max_fit = fitness_values[ilocus]
		dist_from_optimal = ((opt_val - locus.value) / ilocus.range).abs
		dist_fit = dist_from_optimal * (max_fit - min_fit)
		fitness = min_fit + dist_fit

		return fitness
	end

	# Randomize the number of offspring for the next generation based on fitness values
	def num_offspring(fitness)
		num = 0
		ratio = fitness / (fitness + 1.0)
		while true
			break if Environment.rnd.rand > ratio
			num += 1
		end
		return num
	end
end
