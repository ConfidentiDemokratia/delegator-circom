
# Automatic Tally and Vote Submission Circuits
**WARNING - THIS IS A DRAFT**

This repository contains two Circom circuits:

1. `auto_tally.circom`: A circuit for automatic tallying of votes.
2. `auto_vote_submission.circom`: A circuit for automatic vote submission with additional checks.

## auto_tally.circom

The `auto_tally.circom` circuit is designed to automatically tally votes based on predefined constraints. It includes the following checks:

1. `Keccak<HashChainValue, Result> = ParamsHash`: Computes the Keccak hash of `HashChainValue` concatenated with `Result` and compares it with `ParamsHash`.
2. `HashChain<(encVote, pubKey)[]> = HashChainValue`: Generates a hash chain of encrypted votes and public keys and compares it with `HashChainValue`.
3. `Enc<Vote, DHKey> = _encVote`: Encrypts the vote using a Diffie-Hellman key and compares it with `_encVote`.
4. `Sum<Vote> = Result`: Computes the sum of votes and compares it with `Result`.

## auto_vote_submission.circom

The `auto_vote_submission.circom` circuit facilitates automatic vote submission with additional checks. It includes the following constraints:

1. `Keccak<voteContextHash, delegatorEmbeddingHash, _encVote> = publicInput1`: Computes the Keccak hash of `voteContextHash`, `delegatorEmbeddingHash`, and `_encVote` and compares it with `publicInput1`.
2. `Enc<Vote, DHKey> = _encVote`: Encrypts the vote using a Diffie-Hellman key and compares it with `_encVote`.
3. `Model<voteContext, delegatorEmbedding> = Vote`: Models the vote context and delegator embedding and compares it with the vote.
4. `Keccak<voteContext> = voteContextHash`: Computes the Keccak hash of the vote context and compares it with `voteContextHash`.
5. `Keccak<delegatorEmbedding> = delegatorEmbeddingHash`: Computes the Keccak hash of the delegator embedding and compares it with `delegatorEmbeddingHash`.

For more information on integrating these circuits into MACI circuits, refer to the [MACI documentation](https://maci.pse.dev/docs/primitives/).

