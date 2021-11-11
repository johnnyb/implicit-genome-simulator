class Organism
	attr_accessor :implicit_genome
	attr_accessor :loci

	def initialize(igenome, tmp_loci = nil)
		self.implicit_genome = igenome
		if tmp_loci.nil?	
			tmp_loci = []
			igenome.implicit_loci.each do |ilocus|
				tmp_loci.push(Locus.new(ilocus))
			end
		end
		self.loci = tmp_loci
	end

	# Returns a list of organisms for the next round
	def iterate(env)
		fitness = fitness_for_environment(env)
		num_offspring = env.num_offspring(fitness)
		offspring = []
		1.upto(num_offspring) do
			o = duplicate
			o.mutate!
			offspring.push(o)
		end
		return offspring
	end

	# Duplicate myself and return a new organism
	def duplicate
		new_loci = []
		self.loci.each do |locus|
			new_loci.push(locus.duplicate)
		end
		o = Organism.new(implicit_genome, new_loci)
	end

	# Modify my current genome
	def mutate!
		loci.each do |locus|
			locus.possibly_mutate!
		end
	end

	def fitness_for_environment(env)
		fitness_sum = 0.0
		loci.each do |locus|
			fitness_sum += env.fitness_for_locus(locus)
		end
		return fitness_sum / loci.size
	end
end
