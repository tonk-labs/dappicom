# Recursion

The main idea here is to use a kind of map-reduce style approach to recursively aggregate sub-computations into a final proof which we can verify on-chain.

From the trace notes, we will be given the following:
- a segment of computation A, we can denote A_i
  - address sorted tuples of memory
  - opcode partitioned tuples of memory
  - merkle memory tree of A_i_start, A_i_end
  - vector of dirty page bits for the sequence ?? maybe the circuit itself can compute this
  - pre-computed challenge r

## Procedure 1 (memory)

> THOUGHT? could we use commitment scheme to more efficiently test a subset of the trace was used in computing the challenge r?)
>(that would be, we make commitment to the full trace. The commitment is efficiently opened for those entries which make the subset. The challenge r is computed by hash of commitments)
> I don't know of a scheme like this off the top of my head. Maybe we make the challenge r the root of our merkle tree? Haven't thought about this too much, but for now just cracking on.


This procedure can be parallelized and aggregated

## Procedure 1.a (permutation checks)
1. check the address sorted for memory consistency
2. compute the partial challenge r for address sorted and opcode memory inputs 
3. compute partial permutation check for address sorted and opcode memory inputs
4. return partial permutation checks and partial challenges

This procedure can be parallelized per page per (start / end) and aggregated 
## Procedure 1.b (continutation checks)
1. compute the page hash(es) and check merkle inclusion proof(s)
   1. for the beginning merkle tree
   2. for the ending merkle tree
2. compute the (sub) permutation check for addr sorted
3. return sub permutation checks

## Procedure 2 (opcodes)

1. check opcode transitions are correct and consistent
2. compute sub permutation check, using challenge r
3. return sub permutation checks

## Procedure 3 (opcode aggregation)

1. verify opcode a and opcode b
2. combine sub permutation checks
3. return combined sub permutation check


## Procedure 4 (memory aggregation)

1. hash the partial challenges into intermediate aggregate challenges
2. verify the sub permutation and continuation checks
3. return combined sub permutation checks


## Procedure 5 (final memory aggregation)
1. hash the partial challenges into the final aggregate challenge and check challenge r advice arg 
2. verify the last two memory aggregate circuits
3. return computed final permutation checks

## Procedure 6 (final opcode aggregation)
1. verify the last two opcodes
2. combine sub permutation checks into final permutation check
3. return final permutation check

## Procedure 5 (total aggregation)

1. verify the aggregation of opcodes
2. verify the aggregation of memory
3. verify complete product of memory permutation and opcode permutation are identical
4. verify the r used in memory and opcode aggregation is identical

