class Simulator
	attr_accessor :num_environments
	attr_accessor :num_loci
	attr_accessor :num_starting_organisms
	attr_accessor :organisms
	attr_accessor :implicit_genome
	attr_accessor :current_environment
	attr_accessor :environments
	attr_accessor :timestamp

	def reset
		self.timestamp = 0
		self.implicit_genome = ImplicitGenome.new(num_loci)
		self.environments = []
		1.upto(num_environments) do
			e = Environment.new(implicit_genome)
			self.environments.push(e)
		end
		1.upto(num_organisms) do
			o = Organism.new(implicit_genome)
			self.organisms.push(o)
		end
		self.current_environment = environments.shuffle.first
	end

	def iterate!
		self.timestamp += 1
		next_organism_batch = []
		organisms.each do |o|
			next_organism_batch += o.iterate(current_environment)
		end
		change_environment!
	end

	def change_environment!
		# Note - should also have an option to continuously change the environment,
		# like self.current_environment.update! or something
		self.current_environment = environments.shuffle.first
	end

	def initialize
		self.timestamp = 0
		self.num_environments = 50
		self.num_loci = 100
		self.implicit_genome = nil
		self.current_environment = nil
		self.environments = []
	end
end
