<?php

namespace projectx\api\lobby;

use Doctrine\DBAL\Connection;
use projectx\api\entity\Lobby;
use projectx\api\game\GameRepository;
use projectx\api\user\UserRepository;
use Silex\Application;

/**
 * Class LobbyRepository
 * @package projectx\api\lobby
 */
class LobbyRepository
{
    /** @var  Application\ */
    private $app;
    /** @var  Connection */
    private $connection;
    /** @var  UserRepository */
    private $userRepo;
    /** @var  GameRepository */
    private $gameRepo;

    /**
     * LobbyRepository constructor.
     *
     * @param Application $app
     * @param Connection $connection
     */
    public function __construct(Application $app, Connection $connection)
    {
        $this->app = $app;
        $this->connection = $connection;
        $this->userRepo = new UserRepository($app, $connection);
        $this->gameRepo = new GameRepository($app, $connection);
    }

    /**
     * @return array
     */
    public function getAll()
    {
        $sql = <<<EOS
SELECT *
FROM `{$this->getTableName()}`
EOS;

        $lobbies = $this->connection->fetchAll($sql);

        $result = [];
        foreach ($lobbies as $lobby) {
            $lobby = $this->loadUser($lobby);
            $lobby = $this->loadGame($lobby);
            $result[] = Lobby::createFromArray($lobby);
        }
        return $result;
    }

    /**
     * @return string
     */
    public function getTableName()
    {
        return 'lobby';
    }

    /**
     * @param array $lobby
     * @return array
     */
    private function loadUser(array $lobby)
    {
        $userResult = $this->userRepo->getById($lobby['ownerId']);
        $lobby['owner'] = $userResult;
        return $lobby;
    }

    /**
     * @param array $lobby
     * @return array
     */
    private function loadGame(array $lobby)
    {
        $gameResult = $this->gameRepo->getById($lobby['gameId']);
        $lobby['game'] = $gameResult;
        return $lobby;
    }

    /**
     * @param $lobbyId
     * @return Lobby
     */
    public function getById($lobbyId)
    {
        $sql = <<<EOS
SELECT l.*
FROM `{$this->getTableName()}` l
WHERE l.id = :id
EOS;

        $lobbies = $this->connection->fetchAll($sql, ['id' => $lobbyId]);
        if (count($lobbies) === 0) {
            $this->app->abort(400, "Lobby with id $lobbyId does not exist.");
        }
        else {
            $lobbies[0] = $this->loadUser($lobbies[0]);
            $lobbies[0] = $this->loadGame($lobbies[0]);
            return Lobby::createFromArray($lobbies[0]);
        }
    }


    /**
     * @param $userId
     * @return array|Lobby
     */
    public function getByOwnerId($userId)
    {
        $sql = <<<EOS
SELECT l.*
FROM `{$this->getTableName()}` l
WHERE l.ownerId = :ownerId
EOS;

        $lobbies = $this->connection->fetchAll($sql, ['ownerId' => $userId]);
        if (count($lobbies) === 0) {
            $this->app->abort(400, "Lobbies with ownerId $userId does not exist.");
        }
        else {
            $result = [];
            foreach ($lobbies as $lobby) {
                $lobby = $this->loadUser($lobby);
                $lobby = $this->loadGame($lobby);
                $result[] = Lobby::createFromArray($lobby);
            }
            return $result;
        }
    }

    /**
     * @param $gameId
     *
     * @return array|Lobby
     */
    public function getByGameId($gameId)
    {
        $sql = <<<EOS
SELECT l.*
FROM `{$this->getTableName()}` l
WHERE l.gameId = :gameId
EOS;

        $lobbies = $this->connection->fetchAll($sql, ['gameId' => $gameId]);
        if (count($lobbies) === 0) {
            $this->app->abort(400, "Lobbies with gameId $gameId does not exist.");
        }
        else {
            $result = [];
            foreach ($lobbies as $lobby) {
                $lobby = $this->loadUser($lobby);
                $lobby = $this->loadGame($lobby);
                $result[] = Lobby::createFromArray($lobby);
            }
            return $result;
        }
    }

    /**
     * @param Lobby $lobby
     */
    public function create(Lobby $lobby)
    {
        $data = $lobby->jsonSerialize();
        $this->connection->insert("`{$this->getTableName()}`", $data);
        $lobby->setId($this->connection->lastInsertId());
    }
}