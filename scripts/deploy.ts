
import { ethers } from "hardhat";

const name = "My_token";
const symbol = "MTK";
const etfToken = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";
const priceOracle = "0x8626f6940E2eb28930eFb4CeF49B2d1F2C9C1199";

async function main() {

  const cryptoBackedETF = await ethers.deployContract("CryptoBackedETF", [name, symbol, etfToken, priceOracle]);

  await cryptoBackedETF.waitForDeployment();

  console.log("CryptoBackedETF deployed to : ",await cryptoBackedETF.getAddress());
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
