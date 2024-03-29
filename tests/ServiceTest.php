<?php

use Doctrine\DBAL\Connection;

class ServiceTests extends PHPUnit_Framework_TestCase
{
    private $noDataString = '{"data":[null]}';
    private $emptyListString = '{"data":[]}';

    public function testBetService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->exactly(2))->method('abort');

        $betRepo = new \projectx\api\bet\BetRepository($appMock, $connectionMock);
        $betService = new \projectx\api\bet\BetService($betRepo);
        $this->assertNotEmpty($betService->getList());
        $this->assertNotEmpty($betService->getByUserId(1));
        $this->assertNotEmpty($betService->getByLobbyId(1));

        $this->assertEquals($this->emptyListString, $betService->getByUserId(-1)->getContent());
        $this->assertEquals($this->emptyListString, $betService->getByLobbyId(-1)->getContent());
    }


    public function testGameService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->once())->method('abort');

        $gameRepo = new \projectx\api\game\GameRepository($appMock, $connectionMock);
        $gameServive = new \projectx\api\game\GameService($gameRepo);
        $this->assertNotEmpty($gameServive->getList());
        $this->assertNotEmpty($gameServive->getById(1));
        $this->assertNotEmpty($gameServive->getByGenre("somegenre"));

        $this->assertEquals($this->noDataString, $gameServive->getById(-1)->getContent());
    }


    public function testGameAccountService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->exactly(2))->method('abort');

        $gameAccountRepo = new \projectx\api\gameAccount\GameAccountRepository($appMock, $connectionMock);
        $gameAccountService = new \projectx\api\gameAccount\GameAccountService($gameAccountRepo);
        $this->assertNotEmpty($gameAccountService->getList());
        $this->assertNotEmpty($gameAccountService->getByUserId(1));
        $this->assertNotEmpty($gameAccountService->getByTypeId(1));

        $this->assertEquals($this->emptyListString, $gameAccountService->getByUserId(-1)->getContent());
        $this->assertEquals($this->emptyListString, $gameAccountService->getByTypeId(-1)->getContent());
    }


    public function testGameAccountTypeService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->once())->method('abort');

        $gameAccountTypeRepo = new \projectx\api\gameAccountType\GameAccountTypeRepository($appMock, $connectionMock);
        $gameAccountTypeService = new \projectx\api\gameAccountType\GameAccountTypeService($gameAccountTypeRepo);
        $this->assertNotEmpty($gameAccountTypeService->getList());
        $this->assertNotEmpty($gameAccountTypeService->getById(1));

        $this->assertEquals($this->noDataString, $gameAccountTypeService->getById(-1)->getContent());
    }


    public function testLobbyService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->once())->method('abort');

        $lobbyRepo = new \projectx\api\lobby\LobbyRepository($appMock, $connectionMock);
        $lobbyService = new \projectx\api\lobby\LobbyService($lobbyRepo);
        $this->assertNotEmpty($lobbyService->getById(1));
        $this->assertNotEmpty($lobbyService->getList());
        $this->assertNotEmpty($lobbyService->getByOwnerId(1));

        $this->assertEquals($this->noDataString, $lobbyService->getById(-1)->getContent());
    }


    public function testUserService() {
        $connectionMock = $this->getMockBuilder(Connection::class)->disableOriginalConstructor()->getMock();
        $connectionMock->expects($this->any())->method('fetchAll')->will($this->returnCallback(array($this, 'connectionMockCallback')));

        $appMock = $this->getMockBuilder(\projectx\api\Application::class)->disableOriginalConstructor()->getMock();
        $appMock->expects($this->once())->method('abort');

        $userRepo = new \projectx\api\user\UserRepository($appMock, $connectionMock);
        $userService = new \projectx\api\user\UserService($userRepo);
        $this->assertNotEmpty($userService->getById(1));
        $this->assertNotEmpty($userService->getList());

        $this->assertEquals($this->noDataString, $userService->getById(-1)->getContent());
    }




    //this mocks the database
    public function connectionMockCallback($tablename, $idMap) {
        if(count($idMap) !== 0) {
            foreach ($idMap as $key => $value) {
                if ($value === -1)
                    return [];
            }
        }
        if(strpos($tablename, 'bet') !== false)
            return [['userId' => '8b2ca685515eb967ccf945070ed0207f', 'lobbyId' => '8b2ca685515eb967ccf945070ed0207f', 'amount' => 0, 'team' => 0]];
        if(strpos($tablename, 'gameaccountType') !== false)
            return [['id' => '8b2ca685515eb967ccf945070ed0207f', 'name' => "gameAccountTypeName", 'icon' => 'someIcon']];
        if(strpos($tablename, 'gameaccount') !== false)
            return [['userId' => '8b2ca685515eb967ccf945070ed0207f', 'userIdentifier' => "username", 'gameaccountTypeId' => '8b2ca685515eb967ccf945070ed0207f']];
        if(strpos($tablename, 'game') !== false)
            return [['id' => '8b2ca685515eb967ccf945070ed0207f', 'name' => "someName", 'typ' => "sometype", 'icon' => "someIcon", 'rules' => 'someRules', 'genre' => "somegenre", 'timelimit' => 1000]];
        if(strpos($tablename, 'lobby') !== false)
            return [['id' => '8b2ca685515eb967ccf945070ed0207f', 'ownerId' => '8b2ca685515eb967ccf945070ed0207f', 'gameId' => '8b2ca685515eb967ccf945070ed0207f', 'winnerteam' => 1, 'createdAt' => 0, 'starttime' => 0, 'endtime' => 0]];
        if(strpos($tablename, 'user') !== false)
            return [['id' => '8b2ca685515eb967ccf945070ed0207f', 'email' => "someMail", 'username' => "username", 'trusted' => 1, 'password' => 'somePassWord', 'icon' => "someIcon", 'coins' => 0, 'createdAt' => 0]];
        else
            var_dump($tablename);
    }
}