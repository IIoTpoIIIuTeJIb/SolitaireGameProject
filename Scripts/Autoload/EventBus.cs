using Godot;

public partial class EventBus : Node
{

    //      signal cards_dealt
    [Signal]
    public delegate void CardsDealtEventHandler();

    //      signal cards_assmebled(suit : Card.Suit)
    [Signal]
    public delegate void CardsAssembledEventHandler(int suit);

    //      signal game_started
    [Signal]
    public delegate void GameStartedEventHandler();

    //      signal game_ended(game_won : bool)
    [Signal]
    public delegate void GameEndedEventHandler(bool gameWon);

    //      signal card_moved
    [Signal]
    public delegate void CardMovedEventHandler();

    //      signal assembled_pile_undone
    [Signal]
    public delegate void AssembledPileUndoneEventHandler();
}
