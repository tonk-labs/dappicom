# Recursion

The main idea here is to use a kind of map-reduce style approach to recursively aggregate sub-computations into a final proof which we can verify on-chain.

From the trace notes, we will be given the following:
- a segment of computation A, we can denote A_i
  - address sorted tuples of memory
  - opcode partitioned tuples of memory
  - merkle memory tree of A_i_start, A_i_end
  - vector of dirty page bits for the sequence
  - pre-computed challenge r

## Procedure 1 (memory)

(thought, could we use external scheme to more efficiently test the arrays are subsets of full array used in computing the challenge r?)
(that would be, we make commitment to the full array. That commitment is opened for those entries which make the subset. The challenge r is computed by hash of commitments)

This procedure can be parallelized and aggregated
## Procedure 1.a (permutation checks)
1. check the address sorted for memory consistency
2. compute the challenge r for address sorted and opcode memory inputs and check against input
3. perform the premutation check (at final aggregation step)

This procedure can be parallelized per page per (start / end) and aggregated 
## Procedure 1.b (continutation checks)
1. compute the page hash and check merkle inclusion proof
2. compute the (sub) permutation check for addr sorted
3. check address sorted array is subset of page hash (either all reads are in the start array, or final writes are in the end array)

## Procedure 2 (opcodes)

1. check opcode transitions are correct and consistent
2. compute intermediate permutation check, using challenge r

output -> intermediate permutation check result


## Procedure 3 (opcode aggregation)

1. verify opcode a and opcode b
2. combine intermediate permutation checks


## Procedure 4 (memory aggregation)

1. hash the partial challenges into aggregated challenges
2. verify the sub permutation and continuation checks

## Procedure 5 (total aggregation)

1. verify the aggregation of opcodes
2. verify the aggregation of memory
3. verify complete product of memory permutation and opcode permutation are identical
4. hash the intermediate challenges into final challenge and equate to r

