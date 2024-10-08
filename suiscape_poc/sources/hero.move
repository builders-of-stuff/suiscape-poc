module suiscape_poc::hero;

use std::string::{Self, String};
use sui::address;

use suiscape_poc::battle::{Self, BattleHistory};

public struct Hero has key, store {
    id: UID,
    level: u8,
    experience: u64,
    attack: u8,
    defence: u8,
    army: vector<ArmyUnit>,
    battle_history: vector<BattleHistory>,
    resources: Resources
}

public struct ArmyUnit has key, store {
    id: UID,
    name: String,
    tier: u8,
    quantity: u8,
    attack: u8,
    defence: u8,
    health: u8,
    initiative: u8
}

public struct Resources has store, drop {
    wood: u32,
    ore: u32,
    sulfur: u32,
    crystal: u32,
    mercury: u32,
    gems: u32,
}

public fun new_hero(ctx: &mut TxContext): Hero {
    let hero: Hero = Hero {
        id: object::new(ctx),
        level: 1,
        experience: 0,
        attack: 1,
        defence: 1,
        army: vector::empty<ArmyUnit>(),
        battle_history: vector::empty<BattleHistory>(),
        resources: Resources {
            wood: 0,
            ore: 0,
            sulfur: 0,
            crystal: 0,
            mercury: 0,
            gems: 0
        }
    };

    hero
}

public fun new_swordsman(hero: &mut Hero, ctx: &mut TxContext) {
    let swordsman = ArmyUnit { 
        id: object::new(ctx),
        tier: 1,
        quantity: 2, 
        name: string::utf8(b"Swordsman"),
        attack: 1,
        defence: 1,
        health: 3,
        initiative: 1,
    };

    hero.army.push_back(swordsman);
}

public fun delete_hero(hero: Hero) {
    let Hero {
        id,
        level: _,
        experience: _,
        attack: _,
        defence: _,
        army,
        battle_history: _,
        resources: _
    } = hero;

    vector::destroy_empty(army);

    object::delete(id);
}
