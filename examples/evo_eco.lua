--[[

For ecosystemic / viability selection, we no longer have a fixed fitness function. Instead, each organism must maintain viability:
	- Staying alive (energetic & structural integrity)
	- Being able to reproduce (e.g. for sexual reproduction, finding a mate)

Another difference from previous systems is that birth and death of individuals can be asynchronous. 

Basic elements: 
	1. birth
	2. living
	3. viability_test
	4. reproduction
	
A simple example:
	Viability means keeping a positive energy balance
	Reproduction occurs when energy exceeds a certain amount (e.g. 1)
	Energy is drawn from the environment (which gradually replenishes)
	Energy is lost by living, reproducing, moving, etc.
	
We might also want to ensure the population density stays in a certain range, perhaps
	1. start seeding when population is low, and reaping when high
	2. vary the viability severity according to population size


--]]

function 