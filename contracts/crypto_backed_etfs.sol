// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import necessary libraries
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define the ETF contract
contract CryptoBackedETF is Ownable {
    using SafeMath for uint256;

    // Variables for ETF details
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals = 18; // Default to 18 decimal places for most tokens
    uint256 public navPerShare; // Net Asset Value per Share

    // Mapping to track balances of investors
    mapping(address => uint256) public balanceOf;

    // Mapping to track the holdings of the ETF
    mapping(address => uint256) public holdings;

    // ERC20 token representing the ETF shares
    IERC20 public etfToken;

    // Price oracle for obtaining crypto prices
    address public priceOracle;

    // Events to track transactions
    event Purchase(address indexed buyer, uint256 amount, uint256 cost);
    event Redeem(address indexed redeemer, uint256 amount, uint256 receiveAmount);
    event CheckBalance(string text, uint amount);

    
    
    // Constructor to initialize the ETF contract
    constructor(
        string memory _name,
        string memory _symbol,
        address _etfToken,
        address _priceOracle
    ) {
        name = _name;
        symbol = _symbol;
        etfToken = IERC20(_etfToken);
        priceOracle = _priceOracle;
    }

    // Function to allow investors to purchase ETF shares
    function purchase(uint256 amount) external {
        // Ensure that the investor has approved the transfer of tokens to this contract
        require(
            etfToken.transferFrom(msg.sender, address(this), amount),
            "Token transfer failed"
        );

        // Calculate the cost in ETH
        uint256 cost = amount.mul(navPerShare).div(10**uint256(decimals));

        // Update the investor's balances
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);

        // Update the ETF holdings
        holdings[address(this)] = holdings[address(this)].add(amount);

        // Emit purchase event
        emit Purchase(msg.sender, amount, cost);
    }

    // Function to allow investors to redeem ETF shares
    function redeem(uint256 amount) external {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        // Calculate the redemption value in ETH
        uint256 redemptionValue = amount.mul(navPerShare).div(10**uint256(decimals));

        // Update the investor's balances
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);

        // Update the ETF holdings
        holdings[address(this)] = holdings[address(this)].sub(amount);

        // Transfer the redemption value in ETH to the investor
        require(
            etfToken.transfer(msg.sender, redemptionValue),
            "Token transfer failed"
        );

        // Emit redeem event
        emit Redeem(msg.sender, amount, redemptionValue);
    }

    // Function to update the Net Asset Value (NAV) of the ETF
    function updateNAV() external {
        // Call the price oracle to obtain the latest NAV
        navPerShare = IPriceOracle(priceOracle).getLatestNAV();
    }
    
    function getBalance(address user_account) external returns (uint){
    
       string memory data = "User Balance is : ";
       uint user_bal = user_account.balance;
       emit CheckBalance(data, user_bal );
       return (user_bal);

    }
}

// Interface for a price oracle
interface IPriceOracle {
    function getLatestNAV() external view returns (uint256);
}
