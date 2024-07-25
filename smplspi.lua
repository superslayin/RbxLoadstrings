if getgenv().SmplSpiExecuted and type(getgenv().SmplSpiShutdown) == "function" then
    getgenv().SmplSpiShutdown()
end
