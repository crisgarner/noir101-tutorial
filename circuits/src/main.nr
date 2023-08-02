use dep::std::hash::pedersen;

fn main(required_address : Field, required_value : Field, required_signature : Field, required_data : Field, call_address : pub Field, call_value : pub Field, call_signature : pub Field, call_data : pub Field) {
    let requiredHash = pedersen([required_address, required_value, required_signature, required_data]);
    let secretHash = pedersen([call_address, call_value, call_signature, call_data]);
    assert(secretHash == requiredHash);
}
