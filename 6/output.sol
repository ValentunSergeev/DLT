interface Abi2Sol {
	function unpause () external returns ( bool );
	function paused () external view returns ( bool );
	function pause () external returns ( bool );
	function owner () external view returns ( address );
	function transferOwnership (address newOwner) external;
	event Pause ();
	event Unpause ();
}