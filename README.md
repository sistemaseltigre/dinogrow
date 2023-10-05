# DINOGROW

![DINOGROW Logo](https://github.com/sistemaseltigre/dinogrow/raw/master/assets/images/logo.jpeg)

DINOGROW is an exciting mobile game developed in Flutter that combines the fun of dinosaur games with the power of the Solana blockchain. In this game, players can create a new wallet on the Solana blockchain as their in-game identity, allowing them to interact with the blockchain quickly and transparently.

## Key Features

- Solana Login: Players can log in to the game and generate a new wallet on the Solana blockchain, which acts as their avatar in the game.
- NFTs and Paid Games: Players who own NFTs can participate in paid matches and compete for rewards. Rewards are divided among the top 3 players on the leaderboard every 24 hours.
- Offline Mode: DINOGROW allows players to enjoy the game without an internet connection. You can play anywhere and decide when to synchronize blockchain transactions later.
- Dinosaur Games: The project focuses on creating a series of dinosaur mini-games that interact with the Solana blockchain, providing a unique gaming experience.

## Objectives

- Hackathon Participation: Our main goal is to develop at least one dinosaur mini-game before the end of the Solana Hyperdrive Hackathon.

- Open Source: This project is entirely open source. Anyone can download and use it as a foundation for creating their own mobile blockchain game. We are using Flutter and Flutter Flame, along with the Solana and Solana Web3 libraries to ensure functionality and stability.

## Quicknode Integration

In this project, we utilize Quicknode and its NFT API to seamlessly access Solana NFTs. Quicknode provides a fast and easy way to interact with the Solana blockchain, enhancing the user experience.

## Set up .env

Create a .env File: You need to create a .env file at the root of your project directory. This file should contain the following two environment variables:
QUICKNODE_RPC_URL and QUICKNODE_RPC_WSS with the appropriate RPC URL and WebSocket URL that you want to use.

```bash
QUICKNODE_RPC_URL=https://your-quicknode-rpc-url.com
QUICKNODE_RPC_WSS=wss://your-quicknode-websocket-url.com
```

Note: These settings will enable your application to connect to Quicknode's Solana API for NFT functionality. If you use other RPCs, obtaining data from the nft may not work the same way.

Example .env content:

## Getting Started

If you want to try DINOGROW or contribute to the project, follow these steps:

- Clone the Repository: Clone this repository to your local machine using the following command:

```bash
    git clone https://github.com/YourUsername/DINOGROW.git
```

- Install Dependencies: Make sure you have Flutter and the Solana and Solana Web3 libraries installed. Then, install the project's dependencies:

```bash
    flutter pub get
```

- Run the Game: Start the game on your device or emulator with the following command:

```bash
    flutter run
```

## Contributions

We welcome contributions from the community! If you'd like to collaborate on the project, please follow these guidelines:

Fork the repository.
Make your changes in a new branch.
Submit a pull request (PR) describing your changes concisely.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contact

If you have any questions or suggestions, feel free to contact us:

Email: dinogrow@​yahoo.com

Twitter: @DIN0GR0W

We hope you enjoy DINOGROW, and we hope this project inspires others to create mobile SOLANA blockchain games. Have fun playing and developing!
