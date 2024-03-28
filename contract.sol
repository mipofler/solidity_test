function swapPairV2(
        address router,
        address tokenIn,
        address tokenOut,
        uint256 amountIn,
        uint256 amountOutMin,
        uint256 deadline,
        bool minusOne
    ) public checkDeadline(deadline) onlyOwner returns (uint256) {
        if (amountIn == 0) {
            require(amountOutMin > 0, 'amountOutMin is zero');
            amountIn = IERC20(tokenIn).balanceOf(address(this));
            if (minusOne) {
                amountIn -= 1;
            }
        }

        IERC20(tokenIn).approve(router, amountIn);

        address[] memory path;
        path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        uint256 amountOut = IUniswapV2Router02(router).swapExactTokensForTokens(amountIn, 0, path, address(this), deadline)[1];

        address pool = IUniswapV2Factory(IUniswapV2Router02(router).factory()).getPair(tokenIn, tokenOut);
        (uint256 reserveIn, uint256 reserveOut) = UniswapV2Library.getReserves(pool, tokenIn, tokenOut);
        require(amountOut >= amountOutMin,
            string.concat("aom ", Strings.toString(amountIn), " ", Strings.toString(amountOut), " ", Strings.toString(amountOutMin), " ", Strings.toString(reserveIn), " ", Strings.toString(reserveOut)));

        return amountOut;
    }
