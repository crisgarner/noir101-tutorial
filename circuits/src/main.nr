use dep::std::hash::poseidon;

fn main(secretCallHash: Field, address : pub Field, value : pub Field, signature : pub Field, data : pub Field) {
    let hash = poseidon::bn254::hash_4([address,value,signature,data]);
    assert(secretCallHash == hash);
}
