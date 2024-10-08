module suiscape_poc::battle;

use std::string::{Self, String};

public struct BattleHistory has store, drop {
    texts: vector<String>,
    numbers: vector<u8>
}
