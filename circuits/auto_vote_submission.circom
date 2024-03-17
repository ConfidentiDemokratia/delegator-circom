pragma circom 2.0.0;


/*
   This circuit has the following check:
   1. Keccack<voteContextHash, delegatorEmbeddingHash, _encVote>=publicInput1
   2. Enc<Vote, DHKey> = _encVote
   3. Model<voteContext, delegatorEmbedding> = Vote
   4. Keccack<voteContext> = voteContextHash
   5. Keccack<delegatorEmbedding> = delegatorEmbeddingHash
*/
include "lib/keccak256.circom";
include "lib/poseidon.circom"; // Include the relevant hashing libraries

template KeccakHash(inputs) {
    signal hash;
    hash <== keccak256(inputs);
}

template PoseidonHash(inputs) {
    signal hash;
    hash <== poseidon(inputs);
}

template EncryptionGate(_vote, _dhKey, _encVote) {
    signal vote;
    signal dhKey;
    signal encVote;

    vote <== _vote;
    dhKey <== _dhKey;
    encVote <== _encVote;
}

template ModelGate(_voteContext, _delegatorEmbedding, _vote) {
    signal voteContext;
    signal delegatorEmbedding;
    signal vote;

    voteContext <== _voteContext;
    delegatorEmbedding <== _delegatorEmbedding;
    vote <== _vote;
}

// Define the main circuit
circuit main {

    // Define inputs
    signal publicInput1;
    signal voteContext;
    signal delegatorEmbedding;
    signal vote;
    signal dhKey;
    signal _encVote;

    // Define outputs
    signal voteContextHash;
    signal delegatorEmbeddingHash;

    // Define intermediary signals
    signal _vote;
    signal _voteContextHash;
    signal _delegatorEmbeddingHash;

    // Constraints

    // Constraint 1: Keccak<voteContextHash, delegatorEmbeddingHash, _encVote> = publicInput1
    signal concatenatedInput = concat(voteContextHash, delegatorEmbeddingHash, _encVote);
    signal hashedInput;
    hashedInput <== KeccakHash(concatenatedInput);
    hashedInput === publicInput1;

    // Constraint 2: Enc<Vote, DHKey> = _encVote
    EncryptionGate(vote, dhKey, _encVote);

    // Constraint 3: Model<voteContext, delegatorEmbedding> = Vote
    ModelGate(voteContext, delegatorEmbedding, vote);

    // Constraint 4: Keccak<voteContext> = voteContextHash
    voteContextHash <== KeccakHash(voteContext);

    // Constraint 5: Keccak<delegatorEmbedding> = delegatorEmbeddingHash
    delegatorEmbeddingHash <== KeccakHash(delegatorEmbedding);

    // Define main circuit inputs
    witness publicInput1, voteContext, delegatorEmbedding, vote, dhKey, _encVote;

    // Define main circuit outputs
    output voteContextHash, delegatorEmbeddingHash;
}
