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
forge test --fork-url $SONIC_RPC  -vvv
```