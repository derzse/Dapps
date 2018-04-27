pragma solidity 0.4.23;

contract Montyhall {
    address public owner;
    uint256 public minimumBet = 100 finney;
    uint256 public totalBet;
    uint256 public numberOfBets;
    uint256 public maxAmountOfBets = 100;
    address[] public players;


    struct Player {
        uint256 amountBet;
        uint256 numberSelected;
    }
   
    mapping(address => Player) public playerInfo;

    function() public payable {}

    function Montyhall(uint256 _minimumBet) public {
        owner = msg.sender;
        if(_minimumBet > 0 ) minimumBet = _minimumBet;	
    }

    function kill() public {
        if(msg.sender == owner) selfdestruct(owner);
    }

    function checkPlayerExists(address player) public constant returns(bool){
        for(uint256 i = 0; i < players.length; i++){
            if(players[i] == player) return true;
        }
        return false;
    }

    // Betting for a number between 1 and 3
    function bet(uint256 numberSelected) public payable {
        require(!checkPlayerExists(msg.sender));
        require(numberSelected >= 1 && numberSelected <= 3);
        require(msg.value >= minimumBet);
        playerInfo[msg.sender].amountBet = msg.value;
        playerInfo[msg.sender].numberSelected = numberSelected;
        numberOfBets++;
        players.push(msg.sender);
        totalBet += msg.value;
    }

    // Generates the winning number between 1 and 3
    function generateNumberWinner() public {
        uint time = block.timestamp;
        uint b = block.number; 
        uint256 numberGenerated = uint256(keccak256(blockhash(b), time)) % 3 + 1;
        distributePrizes(numberGenerated);
    }

    // Ether distribution to the winner
    function distributePrizes(uint256 numberWinner) public {
        address[100] memory winners;
        uint256 count = 0;

        for(uint256 i = 0; i < players.length; i++){
            address playerAddress = players[i];
            if(playerInfo[playerAddress].numberSelected == numberWinner){
                winners[count] = playerAddress;
                count++;
            }
            delete playerInfo[playerAddress];
        }

        uint256 winnerEtherAmount = totalBet / winners.length;

        for(uint256 j = 0; j < count; j++){
         if(winners[j] != address(0))
            winners[j].transfer(winnerEtherAmount);
        }
      
        players.length = 0;
        totalBet = 0;
        numberOfBets = 0;
   }
}
