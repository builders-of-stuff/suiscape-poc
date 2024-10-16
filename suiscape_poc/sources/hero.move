module suiscape_poc::hero;

use std::string::{Self, String};
use sui::coin::{Self, Coin};
use sui::random::{Self, Random};
use sui::address;

use suiscape_poc::gold::{GOLD};

const GOLD_BANK: address = @0x0;
const SWORDSMAN_COST: u64 = 100; // Cost per swordsman in GOLD

const EInsufficientFunds: u16 = 0;


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

public struct BattleHistory has store, drop {
    texts: vector<String>,
    numbers: vector<u8>
}

public struct ArmyUnit has key, store {
    id: UID,
    name: String,
    tier: u8,
    quantity: u32,
    attack: u8,
    defence: u8,
    damage_low: u32,
    damage_high: u32,
    health: u32,
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

public fun new_pikeman(hero: &mut Hero, quantity: u32, ctx: &mut TxContext) {
    let pikeman = ArmyUnit { 
        id: object::new(ctx),
        tier: 1,
        quantity, 
        name: string::utf8(b"pikeman"),
        attack: 4,
        defence: 5,
        damage_low: 1,
        damage_high: 3,
        health: 10,
        initiative: 4,
    };

    hero.army.push_back(pikeman);
}

public fun new_swordsman(hero: &mut Hero, quantity: u32, ctx: &mut TxContext) {
    let swordsman = ArmyUnit { 
        id: object::new(ctx),
        tier: 2,
        quantity, 
        name: string::utf8(b"swordsman"),
        attack: 10,
        defence: 12,
        damage_low: 6,
        damage_high: 9,
        health: 35,
        initiative: 5,
    };

    hero.army.push_back(swordsman);
}

public fun new_angel(hero: &mut Hero, quantity: u32, ctx: &mut TxContext) {
    let angel = ArmyUnit { 
        id: object::new(ctx),
        tier: 3,
        quantity, 
        name: string::utf8(b"angel"),
        attack: 20,
        defence: 20,
        damage_low: 50,
        damage_high: 50,
        health: 200,
        initiative: 8,
    };

    hero.army.push_back(angel);
}

entry fun battle(hero: &mut Hero, random: &Random, ctx: &mut TxContext) {  
    let army = &mut hero.army;

    let mut enemy_army = vector[ArmyUnit {
        id: object::new(ctx),
        tier: 1,
        quantity: 5, 
        name: string::utf8(b"wolf"),
        attack: 5,
        defence: 2,
        health: 7,  
        damage_low: 1,
        damage_high: 4,
        initiative: 7,
    }];

    let mut is_battling = true;
    let mut battle_messages = vector::empty<String>();
    let mut battle_numbers = vector::empty<u8>();
    let mut generator = random::new_generator(random, ctx);

    while (is_battling) {
        let attacker = vector::pop_back(army);
        let mut defender: ArmyUnit = vector::pop_back(&mut enemy_army);

        let mut attacker_damage = random::generate_u32_in_range(&mut generator, attacker.damage_low, attacker.damage_high);
        let mut defender_damage = random::generate_u32_in_range(&mut generator, defender.damage_low, defender.damage_high);

        let attacker_damage_modifier = if (attacker.attack > defender.defence / 2) {
            attacker.attack - defender.defence / 2
        } else {
            0
        };
        let defender_damage_modifier = if (defender.attack > attacker.defence / 2) {
            defender.attack - attacker.defence / 2
        } else {
            0
        };

        attacker_damage = if (attacker_damage_modifier > 0) {
            // This gives a 1% increase for each point in attacker_damage_modifier
            let percentage_increase = (100 + attacker_damage_modifier) as u32;
    
            // Apply the percentage increase to the attacker_damage
            attacker_damage * (percentage_increase / 100)

        } else {
            attacker_damage
        };


        let attacker_damage = attacker.attack - defender.defence / 2;
        defender.health = defender.health - attacker_damage;

        vector::push_back(&mut battle_messages, attacker.name);
        vector::push_back(&mut battle_numbers, attacker_damage);
        
        if (defender.health <= 0) {
            is_battling = false;

            let ArmyUnit { 
                id: defender_id, 
                tier: _, 
                quantity: _, 
                name: _, 
                attack: _, 
                defence: _, 
                damage_low: _,
                damage_high: _,
                health: _, 
                initiative: _,  
            } = defender;
            object::delete(defender_id);
            vector::push_back(army, attacker);

        } else {
          vector::push_back(army, attacker);
          vector::push_back(&mut enemy_army, defender);
        }
    };

    enemy_army.destroy_empty();

    let what_happened = BattleHistory {
        texts: battle_messages,
        numbers: battle_numbers,
    };

    hero.battle_history.push_back(what_happened);
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
