uses classes,sysutils,PacketUnit;

const DEBUG:boolean = true;

var TradeTargetName:string;
    TradeTarget:TL2Control;
    trade_obj:TL2Object;
    

procedure SendTradeRequestToTarget(E:TL2Control);
var Pck: TNetworkPacket;
begin
   if DEBUG then begin
     print(E.GetUser.name + ': Sending trade request to ' + E.GetUser.Target.Name);
   end;
   Pck:= TNetworkPacket.Create;       // create packet variable
   Pck.WriteC($15);                   // TradeRequest:d(ObjectID)
   pck.WriteD(E.GetUser.Target.OID);  //d(ObjectID)
   E.SendToServer(Pck.ToHex);         // send formatted to HEX packet to the server
   Pck.Free;    
   delay(1000);
end;

procedure AcceptTradeRequest(E:TL2Control);
var Pck: TNetworkPacket;
begin
   if DEBUG then begin
     print(E.GetUser.name + ': Accepting trade request (if exists).');
   end;
   Pck:= TNetworkPacket.Create;    // create packet variable
   Pck.WriteC($44);                // AnswerTradeRequest:d(answer)
   pck.WriteD(1);                  // d(answer)
   E.SendToServer(Pck.ToHex);      // send formatted to HEX packet to the server
   Pck.Free;
   delay(1000);
end;

procedure AddItemToTrade(E:TL2Control; item:TL2Object; cnt:cardinal);
var Pck: TNetworkPacket;
begin
   if DEBUG then begin
     print(E.GetUser.name + ': Adding to trade ' + intToStr(cnt) + ' of ' + item.name );
   end;
   Pck:= TNetworkPacket.Create;    // create packet variable
   Pck.WriteC($16);                // AddTradeItem:d(TradeID)d(ObjectID)d(Count)
   pck.WriteD(0);                  // d(TradeID)
   pck.WriteD(item.OID);           // d(ObjectID)
   pck.WriteD(cnt);                // d(Count)
   E.SendToServer(Pck.ToHex);      // send formatted to HEX packet to the server
   Pck.Free;
   delay(1000);
end;

procedure AcceptTradeDlg(E:TL2Control);
var Pck: TNetworkPacket;
begin
   if DEBUG then begin
     print(E.GetUser.name + ': Accepting trade dialog (if exists).');
   end;
   Pck:= TNetworkPacket.Create;    // create packet variable
   Pck.WriteC($17);                // TradeDone:d(Response)
   pck.WriteD(1);                  // d(answer)
   E.SendToServer(Pck.ToHex);      // send formatted to HEX packet to the server
   Pck.Free;
   delay(1000);
end;

begin
  TradeTargetName := 'Gaham';
  TradeTarget := GetControl(TradeTargetName);
  Engine.SetTarget(TradeTargetName);
  delay(300);
  Engine.MoveToTarget();

  SendTradeRequestToTarget(Engine);
  AcceptTradeRequest(TradeTarget);
  if Inventory.User.ByID(57, trade_obj) then
    AddItemToTrade(Engine, trade_obj, 1);      //1 adena
  AcceptTradeDlg(Engine);
  AcceptTradeDlg(TradeTarget);
  print('done!');
end.
