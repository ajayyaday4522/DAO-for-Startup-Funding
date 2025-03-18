module MyModule::StartupDAO {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing the DAO investment pool.
    struct InvestmentPool has store, key {
        total_funds: u64,
    }

    /// Function to initialize the DAO investment pool.
    public fun create_pool(admin: &signer) {
        let pool = InvestmentPool {
            total_funds: 0,
        };
        move_to(admin, pool);
    }

    /// Function to contribute funds to the DAO investment pool.
    public fun contribute(contributor: &signer, dao_address: address, amount: u64) acquires InvestmentPool {
        let pool = borrow_global_mut<InvestmentPool>(dao_address);

        // Transfer the contribution from the contributor to the DAO
        let contribution = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(dao_address, contribution);

        // Update total funds in the DAO pool
        pool.total_funds = pool.total_funds + amount;
    }
}
