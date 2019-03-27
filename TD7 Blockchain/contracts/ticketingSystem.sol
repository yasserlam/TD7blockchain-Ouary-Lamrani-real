pragma solidity >= 0.4.22 <0.6.0;

contract ticketingSystem{


    
   uint Nb_Artist=1;
   
   
   struct Artist{
   
   bytes32 name;
   uint artistCategory;
   uint ticketssold;   
   address owner;
   uint ID;
   }
  
  
  mapping(uint => Artist) public artistsRegister;
  
  function createArtist(bytes32 _name,uint _category) public
  {
      artistsRegister[Nb_Artist].owner=msg.sender;
      artistsRegister[Nb_Artist].name=_name;
	  artistsRegister[Nb_Artist].artistCategory=_category;
	  artistsRegister[Nb_Artist].ID=Nb_Artist;
	  artistsRegister[Nb_Artist].ticketssold=0;
	  Nb_Artist++;
  }
  
  
  function modifyArtist(uint newID,bytes32 newname,uint newcategory,address newowner) public
  {
     require(artistsRegister[newID].owner==msg.sender);
     artistsRegister[newID].name=newname;
	 artistsRegister[newID].artistCategory=newcategory;
	 artistsRegister[newID].owner=newowner;
     artistsRegister[newID].ticketssold=10;
  }
  
  uint Nb_Venue=1;
   
  struct Venue{
   
   bytes32 name;
   uint capacity;      
   address owner;
   uint ID;
   uint standardComission;
   
   }
  
  mapping(uint => Venue) public venuesRegister;
  
  function createVenue(bytes32 _name,uint _capacity, uint comi) public
  {
      venuesRegister[Nb_Venue].owner=msg.sender;
      venuesRegister[Nb_Venue].name=_name;
	  venuesRegister[Nb_Venue].capacity=_capacity;
	  venuesRegister[Nb_Venue].ID=Nb_Venue;

	  venuesRegister[Nb_Venue].standardComission=comi;
	  Nb_Venue++;	
  }
  
  function modifyVenue(uint newID,bytes32 newname,uint _capacity, uint comi, address newowner) public
  {
     require(venuesRegister[newID].owner==msg.sender);
     venuesRegister[newID].name=newname;
	 venuesRegister[newID].capacity=_capacity;
	 venuesRegister[newID].owner=newowner;
     venuesRegister[newID].standardComission=comi;
  }
  
  uint Nb_Object=1;
  
  struct Object{
  address owner;
  uint date; 
  uint id_artist;
  uint id_venue; 
  bool isAvailable;
  bool isAvailableForSale;
  uint concertId;
  bool isused;
  
  }
  
  mapping(uint => Object) public tickets;
  
    function createTicket(uint _id_artist,uint _id_venue, uint date) public
  {
      tickets[Nb_Object].owner=msg.sender;
      tickets[Nb_Object].date=date;
	  tickets[Nb_Object].id_artist=_id_artist;
	  tickets[Nb_Object].id_venue=_id_venue;

	  
	  Nb_Object++;	
  }
  
  uint Nb_Concert=1;
  
  struct Concert{
  uint concertDate;
  uint ticketsPrice;
  address owner;
  uint artistId; 
  uint venueId;
  uint concertId;
  bool validatedByArtist;
  bool validatedByVenue;
  uint totalSoldTicket;
  
  
  }  
  
  mapping(uint => Concert) public concertsRegister;
  
  
  function createConcert(uint _id_artist,uint _id_venue,uint _concertDate,uint _ticketsPrice) public
  {
  
      concertsRegister[Nb_Concert].owner=msg.sender;
      concertsRegister[Nb_Concert].concertDate=_concertDate;
	  concertsRegister[Nb_Concert].artistId=_id_artist;
	  concertsRegister[Nb_Concert].venueId=_id_venue;
	  concertsRegister[Nb_Concert].ticketsPrice=_ticketsPrice;
 
	  
	  Nb_Concert++;	
  
  
  
  }
  
  uint nextTicketId=1;
  
  function emitTicket(uint _concertId, address ownerAddress) public {
	
	require(artistsRegister[concertsRegister[_concertId].artistId].owner == msg.sender);
	require(now < concertsRegister[_concertId].concertDate);
	require(concertsRegister[_concertId].totalSoldTicket < venuesRegister[concertsRegister[_concertId].venueId].capacity);
	
	tickets[nextTicketId].owner = ownerAddress;
	tickets[nextTicketId].date = concertsRegister[_concertId].concertDate;
	tickets[nextTicketId].id_venue = concertsRegister[_concertId].venueId;
	tickets[nextTicketId].id_artist = concertsRegister[_concertId].artistId;
	tickets[nextTicketId].concertId = _concertId;
	tickets[nextTicketId].isAvailable = true;
	tickets[nextTicketId].isAvailableForSale = false;
	
	concertsRegister[_concertId].totalSoldTicket ++;
	
	nextTicketId ++;
	
	
	}
	
	
   function useTicket(uint _ticketId) public
   {
       require(concertsRegister[_ticketId].concertDate == now);
	   
	   tickets[nextTicketId].isused = true;
	   
	   nextTicketId ++;
   
   
   
   }
  
  
    
  function validateConcert(uint _concertId) public
	{
		require(concertsRegister[_concertId].concertDate >= now);

		if (venuesRegister[concertsRegister[_concertId].venueId].owner == msg.sender)
		{
		concertsRegister[_concertId].validatedByVenue = true;
		}
		if (artistsRegister[concertsRegister[_concertId].artistId].owner == msg.sender)
		{
		concertsRegister[_concertId].validatedByArtist = true;
		}
	}
  
 
  

}