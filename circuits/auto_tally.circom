/*
    1. Keccak<HashChainValue, Result> = ParamsHash
    2. HashChain<(encVote, pubKey)[]> = HashChainValue
    3. Enc<Vote, DHKey> = _encVote
    4. Sum<Vote> = Result
*/

include "lib/keccak256.circom";
include "lib/poseidon.circom";

// Template for computing Keccak256 hash
template KeccakHash(inputs) {
    signal hash; // Output signal representing the hash value

    // Compute the Keccak256 hash of the inputs
    hash <== keccak256(inputs);
}

// Template for generating a hash chain
template HashChain(inputs[]) {
    signal hashChainValue; // Output signal representing the hash chain value

    // Compute the hash chain value using Poseidon hash function
    hashChainValue <== poseidon(inputs);
}

// Template for performing encryption
template EncryptionGate(_vote, _dhKey, _encVote) {
    signal vote;    // Input signal representing the vote
    signal dhKey;   // Input signal representing the Diffie-Hellman key
    signal encVote; // Output signal representing the encrypted vote

    // Assign inputs to the corresponding signals
    vote <== _vote;
    dhKey <== _dhKey;

    // Assign the encrypted vote to the output signal
    encVote <== _encVote;
}

// Template for summing up votes
template SumGate(votes[]) {
    signal result; // Output signal representing the sum of votes

    // Compute the sum of votes
    result <== sum(votes);
}

// Main circuit definition
circuit main {

    // Define inputs
    signal ParamsHash;         // Input representing the parameters hash
    signal HashChainValue;     // Input representing the hash chain value
    signal DHKey;              // Input representing the Diffie-Hellman key
    signal EncryptedVote;      // Input representing the encrypted vote
    signal Vote;               // Input representing a single vote
    signal PublicKey;          // Input representing a public key

    // Define outputs
    signal Result;             // Output representing the result of computations

    // Define intermediary signals
    signal _encVote;           // Intermediate signal for storing the encrypted vote
    signal _hashChainValue;    // Intermediate signal for storing the hash chain value
    signal _vote;              // Intermediate signal for storing a single vote

    // Constraints

    // Constraint 1: Keccak<HashChainValue, Result> = ParamsHash
    signal concatenatedInput1 = concat(HashChainValue, Result);
    signal hashedInput1;
    hashedInput1 <== KeccakHash(concatenatedInput1);
    hashedInput1 === ParamsHash;

    // Constraint 2: HashChain<(EncryptedVote, PublicKey)[]> = HashChainValue
    signal concatenatedInput2 = concat(EncryptedVote, PublicKey);
    signal hashedInput2;
    hashedInput2 <== HashChain(concatenatedInput2);
    hashedInput2 === HashChainValue;

    // Constraint 3: Enc<Vote, DHKey> = EncryptedVote
    EncryptionGate(Vote, DHKey, _encVote);
    _encVote === EncryptedVote;

    // Constraint 4: Sum<Vote> = Result
    SumGate(Vote); // Assuming Vote is an array of individual votes
    Result === sum(Vote);

    // Define main circuit inputs
    witness ParamsHash, HashChainValue, DHKey, EncryptedVote, Vote[], PublicKey;

    // Define main circuit outputs
    output Result;
}
