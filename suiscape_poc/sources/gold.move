module suiscape_poc::gold;

use std::ascii;
use sui::url;
use sui::coin::{Self, TreasuryCap};

public struct GOLD has drop {}

public struct TreasuryCapHolder has key {
    id: UID,
    treasury_cap: TreasuryCap<GOLD>
}

fun init(witness: GOLD, ctx: &mut TxContext) {
    let (treasury_cap, coin_metadata) = coin::create_currency(
        witness,
        0,
        b"GOLD",
        b"Gold",
        b"A shiny coin",
        option::some(url::new_unsafe(ascii::string(b"https://keylayapps.nyc3.cdn.digitaloceanspaces.com/gm-sui-coin.png"))),
        ctx
    );

    transfer::public_freeze_object(coin_metadata);

    let treasury_cap_holder = TreasuryCapHolder {
        id: object::new(ctx),
        treasury_cap,
    };
    
    transfer::share_object(treasury_cap_holder);
}

public fun mint_one(
    treasury_cap_holder: &mut TreasuryCapHolder,
    ctx: &mut TxContext
) {
    let treasury_cap = &mut treasury_cap_holder.treasury_cap;

    coin::mint_and_transfer(treasury_cap, 1, tx_context::sender(ctx), ctx)
}
