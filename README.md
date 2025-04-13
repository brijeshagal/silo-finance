## Commands

Install dependencies and build

```bash
forge install && forge build
```

Use the `.env.example` for vars
```bash
source .env
```

### Scripts
Run the Looping script file (`Looping.s.sol`).


```bash
forge script ./script/Looping.s.sol --fork-url $SONIC_RPC -- --vvvv
```