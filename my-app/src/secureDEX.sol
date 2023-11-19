// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// API3
interface IProxy {
    function read() external view returns (int224 value, uint32 timestamp);

    function api3ServerV1() external view returns (address);
}

contract secureDEX{

    IERC20 public USDC;
    IERC20 public ETH;
    uint256 public reserveUSDC;
    uint256 public reserveETH;
    address public admin;
    address public proxyAddress;

    event LiquidityAdded(uint256 usdcAmount, uint256 ethAmount);
    event TokensSwapped(address tokenIn, uint256 amountIn, uint256 amountOut);
    event PoolCreated(address USDC, address ETH);
    
    constructor(address _proxyAddress) {
        admin = msg.sender; // Set admin
        proxyAddress = _proxyAddress;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }


    function createPool(address _USDC, address _ETH) public onlyAdmin {
        require(_USDC != address(0) && _ETH != address(0), "Invalid token addresses");
        USDC = IERC20(_USDC);
        ETH = IERC20(_ETH);
        emit PoolCreated(_USDC, _ETH);
    }

    function updateTokenAddresses(address _USDC, address _ETH) public onlyAdmin {
        require(_USDC != address(0) && _ETH != address(0), "Invalid token addresses");
        USDC = IERC20(_USDC);
        ETH = IERC20(_ETH);
    }

    function addLiquidity(uint256 _amountUSDC, uint256 _amountETH) public {
        require(address(USDC) != address(0) && address(ETH) != address(0), "Pool not initialized");
        require(USDC.transferFrom(msg.sender, address(this), _amountUSDC), "Failed to transfer Token A");
        require(ETH.transferFrom(msg.sender, address(this), _amountETH), "Failed to transfer Token B");
        reserveUSDC += _amountUSDC;
        reserveETH += _amountETH;
        emit LiquidityAdded(_amountUSDC, _amountETH);
    }

function userProtectedSwap(address _tokenIn, uint256 _amountIn, uint256 _minAmountOut, uint256 _maxSlippage) public returns (uint256 amountOut) {
    require(_tokenIn == address(USDC) || _tokenIn == address(ETH), "Invalid token address for swap");
    require(_maxSlippage >= 1 && _maxSlippage <= 10, "Slippage out of range; must be between 1% and 10% (expressed as number from 1 to 10 in 18 decimal places)");

    // Get ETH price in USDC from the data feed
    (int224 feedPriceInt,) = IProxy(proxyAddress).read();
    require(feedPriceInt > 0, "Data feed price is invalid");
    uint256 feedPrice = uint256(int256(feedPriceInt));
    

    uint256 maxFeedPrice = (feedPrice * (100 + _maxSlippage)) / 100;
    uint256 minFeedPrice = (feedPrice * (100 - _maxSlippage)) / 100;

    if (_tokenIn == address(USDC)) {
        require(_amountIn <= reserveUSDC, "Insufficient liquidity for USDC");
        
        uint256 currentPrice = reserveETH / reserveUSDC; // Price of 1 ETH in USDC
        
        require(currentPrice >= minFeedPrice && currentPrice <= maxFeedPrice, "Slippage exceeds limit");
        
        amountOut = (_amountIn * reserveETH) / reserveUSDC;
        
        require(amountOut >= _minAmountOut, "Insufficient output amount");
        
        USDC.transferFrom(msg.sender, address(this), _amountIn);
        ETH.transfer(msg.sender, amountOut);
        reserveUSDC += _amountIn;
        reserveETH -= amountOut;
    } else {
        require(_amountIn <= reserveETH, "Insufficient liquidity for ETH");
        
        uint256 invertedFeedPrice = feedPrice; // No inversion needed
        
        require(invertedFeedPrice >= minFeedPrice && invertedFeedPrice <= maxFeedPrice, "Slippage exceeds limit");
        
        amountOut = (_amountIn * reserveUSDC) / reserveETH;
        
        require(amountOut >= _minAmountOut, "Insufficient output amount");
        
        ETH.transferFrom(msg.sender, address(this), _amountIn);
        USDC.transfer(msg.sender, amountOut);
        reserveETH += _amountIn;
        reserveUSDC -= amountOut;
    }

    emit TokensSwapped(_tokenIn, _amountIn, amountOut);
}

    function swap(address _tokenIn, uint256 _amountIn) public returns (uint256 amountOut) {
        require(address(USDC) != address(0) && address(ETH) != address(0), "Pool not initialized");
        require(_tokenIn == address(USDC) || _tokenIn == address(ETH), "Invalid token address for swap");
        if (_tokenIn == address(USDC)) {
            require(_amountIn <= reserveUSDC, "Insufficient liquidity for Token A");
            amountOut = (_amountIn * reserveETH) / (reserveUSDC + _amountIn); // Simplified version without fees
            USDC.transferFrom(msg.sender, address(this), _amountIn);
            ETH.transfer(msg.sender, amountOut);
            reserveUSDC += _amountIn;
            reserveETH -= amountOut;
        } else {
            require(_amountIn <= reserveETH, "Insufficient liquidity for Token B");
            amountOut = (_amountIn * reserveUSDC) / (reserveETH + _amountIn); // Simplified version without fees
            ETH.transferFrom(msg.sender, address(this), _amountIn);
            USDC.transfer(msg.sender, amountOut);
            reserveETH += _amountIn;
            reserveUSDC -= amountOut;
        }
        emit TokensSwapped(_tokenIn, _amountIn, amountOut);
    }

    // Function to set the proxy contract address, no access control.
    function setProxyAddress(address _proxyAddress) public onlyAdmin{
        proxyAddress = _proxyAddress;
    }

    // Function to read data from a dAPI via its proxy contract.
    function readDataFeed()
        external
        view
        returns (int224 value, uint256 timestamp)
    {
        // Use the IProxy interface to read a dAPI.
        (value, timestamp) = IProxy(proxyAddress).read();
        // Include your validations for `value` and `timestamp` here, if any.
    }

    // Note that there are no functions to remove liquidity in this version
}


