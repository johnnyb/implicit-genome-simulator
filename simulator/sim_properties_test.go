package simulator

import (
	"math"
	"testing"
)

// Monte Carlo check: E[NumOffspringForFitness(f)] ≈ f (within tolerance)
func TestNumOffspringExpectation(t *testing.T) {
	trials := 200000
	fs := []float32{0.25, 0.5, 1.0, 2.0, 3.0}
	for _, f := range fs {
		sum := 0
		for i := 0; i < trials; i++ {
			sum += NumOffspringForFitness(f)
		}
		mean := float32(sum) / float32(trials)
		// Allow small relative error
		relErr := math.Abs(float64(mean-f)) / float64(f+1e-6)
		if relErr > 0.02 { // 2% tolerance
			t.Fatalf("Expected mean ~= %f, got %f (rel err=%f)", f, mean, relErr)
		}
	}
}

// With mutability=0, no offspring should report didEvolve=true.
// We test this indirectly by generating a single parent’s offspring and
// ensuring that calling Evolve() on duplicates yields false.
func TestNoMutationYieldsNoEvolve(t *testing.T) {
	sim := NewSimulator(5, 1, 0.0) // mutability=0
	env := NewEnvironment(sim.ImplicitGenome)
	parent := sim.Organisms[0]
	// Force a few offspring attempts by making the parent moderately fit
	// (if fitness is too low, this could be flaky; env values are random, but on average ok)
	offspring := parent.OffspringForEnvironment(env)
	for _, child := range offspring {
		// Re-run Evolve() on each child; should still be false with mutability=0
		if child.Evolve() {
			t.Fatalf("Unexpected mutation when mutability=0")
		}
	}
}

func TestFitnessMappingBounds(t *testing.T) {
	igenome := NewImplicitGenome(20, DEFAULT_MUTABILITY)
	env := NewEnvironment(igenome)
	for il, fm := range env.FitnessData {
		if fm.FitnessMin > fm.FitnessMax {
			t.Fatalf("FitnessMin > FitnessMax for L%d", il.LocusId)
		}
		// sample a locus value and check bounds
		loc := NewLocus(il)
		f := env.FitnessForLocus(loc)
		if f < fm.FitnessMin-1e-5 || f > fm.FitnessMax+1e-5 {
			t.Fatalf("Fitness out of bounds for L%d: %f not in [%f,%f]", il.LocusId, f, fm.FitnessMin, fm.FitnessMax)
		}
	}
}

func TestContinuousMutationStepBound(t *testing.T) {
	il := NewImplicitLocus()
	il.LocusType = LOCUS_CONTINUOUS
	il.RangeMax = 1.0
	il.ContinuousChangeMax = 0.1
	il.Mutability = 1.0

	loc := NewLocus(il)
	before := loc.Value
	loc.Mutate()
	delta := loc.Value - before
	if delta < 0 {
		delta = -delta
	}
	if delta > il.ContinuousChangeMax+1e-6 {
		t.Fatalf("Delta %f exceeds ContinuousChangeMax %f", delta, il.ContinuousChangeMax)
	}
	if loc.Value < 0 || loc.Value > 1 {
		t.Fatalf("Continuous value out of [0,1]: %f", loc.Value)
	}
}

func TestDiscreteMutationRange(t *testing.T) {
	il := NewImplicitLocus()
	il.LocusType = LOCUS_DISCRETE
	il.RangeMax = 10
	il.Mutability = 1.0

	loc := NewLocus(il)
	for i := 0; i < 1000; i++ {
		loc.Mutate()
		if loc.Value < 0 || loc.Value > il.RangeMax {
			t.Fatalf("Discrete value out of range: %f", loc.Value)
		}
	}
}
