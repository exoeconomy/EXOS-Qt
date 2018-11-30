// Copyright (c) 2009-2012 The Bitcoin developers
// Distributed under the MIT/X11 software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#include <boost/assign/list_of.hpp> // for 'map_list_of()'
#include <boost/foreach.hpp>

#include "checkpoints.h"

#include "txdb.h"
#include "main.h"
#include "uint256.h"


static const int nCheckpointSpan = 500;

namespace Checkpoints
{
    typedef std::map<int, uint256> MapCheckpoints;

    //
    // What makes a good checkpoint block?
    // + Is surrounded by blocks with reasonable timestamps
    //   (no blocks before with a timestamp after, none after with
    //    timestamp before)
    // + Contains no strange transactions
    //
    static MapCheckpoints mapCheckpoints =
        boost::assign::map_list_of
        (  0,     uint256("0x00000036090a68c523471da7a4f0f958c1b4403fef74a003be7f71877699cab7") )
        (  2,     uint256("0x892f74fe6b462ec612dc745f19b7f299ffb94aabb17a0826a03092c0eb6f83ec") ) // Premine
        ( 10,     uint256("0xd7c9e4381c4b9331be82d13e0b40b932ac624f3fa8b4e80fb8e9f22769095c0a") )
        ( 50,     uint256("0x71b54f5cb27d2b0b1dd34ba89c7ff4fa8e8b37da727373cf98134069fb84803e") )
        ( 100,    uint256("0xf1fbdb26299ca5bac77963cc2ffd9e1830c3f106b87b235b5c731b4b3259d383") )
        ( 500,    uint256("0x72bc96ba513fb55431f335de897bb8ce80d898e17a3d4d5e05c48d1670d5f234") )
        ( 1000,   uint256("0xf8f562cd694b5ca517aca2e1cd5b953c22a185e715209bfc2a6ae8eb0a524289") ) // v1.0.0.2
        ( 5000,   uint256("0x9fbc9dc45a507a287d043b43a55e0623aca4368ca5c655bc1a7a97eef4951d1a") )
        ( 10000,  uint256("0x45e01c13af7625b7289ed12f687864d485f603c2b5dcccfff26789bcbbc20439") )
        ( 14000,  uint256("0xecd5ae5e58ddde01087a4c7f2033252acc7237a7aa958f4cd0eb016b3c11cd0e") )
        ( 18000,  uint256("0x42ee388a72f85e8a63ed81bdaa4d87040a009cff8471f15e5711ab824faedaa7") ) // v1.0.0.3
        ( 20000,  uint256("0xead9d788c5e0a275d9a8434487248d5b5ed1db14de8ea1627dd70ad1e5fb5f5b") )
        ( 25000,  uint256("0x9e889f90ee0a249a84c2c090117be70de8d53466a5f0bb312fde435ad50080f0") )
        ( 30000,  uint256("0xcd878a41441aca4e2903941c374d0caf17d7080fd1c5e37aca9caab63e82f333") )
        ( 35500,  uint256("0x3196c8456be83bc810ef0f6e2b34a0962435e89d0844b9db8070487d5ec91afa") ) // v1.0.0.4
        ( 40000,  uint256("0x4d7b1d7115714d16dce3266087309e898e02a7dc1eb8d3f450c8473836de5a19") )
        ( 45000,  uint256("0x5f110ad2e1fbbb98bcd4d85167c7904631304bbd311144118f631d59795c0f00") )
        ( 47000,  uint256("0x0b834c3a8d77939f5fc2e372bc03925a1170e8d386671a8d0f21fa8e5a9d440e") ) // v1.0.0.5
        ( 60000,  uint256("0xe904061cd883995fa96fa162927f771a3e0a834866cf741da1bf6f64d9807aab") )
        ( 80000,  uint256("0x4991919485bc0c4f1f3b89dde06f90cca64b6eee2887a8f2105ed1f7219b056e") ) // v1.0.0.6
        ( 100000, uint256("0x5be1f76165c7133562cdcb3beeac6413aea18e538883e379d5929c6eb26999d1") )
        ( 125000, uint256("0xd2f245d326e4e0f1e9e22f548496ca9e47025721d7fece27e071a9f63628f0b8") )
        ( 150000, uint256("0x4b4325e2c02654284de2719033c0defba485bd08a6259ca67372600447bf084e") )
        ( 200000, uint256("0x4e4e40dc5cc007135f5113e1ebb22b06c39cff15637b5f51d93340a9cad0dfdf") )
        ( 250000, uint256("0x20c97546de02e60c2d53a9c95e65956a3d89e81eb5f7075882fac2d6cc24d316") )
        ( 300000, uint256("0x1dca0bf2f051429e911fa9b232fcdf69bbaed667fa55451a3ff4d6450ae5dc52") )        
    ;


    static MapCheckpoints mapCheckpointsTestnet =
        boost::assign::map_list_of
        (  0,     uint256("0x0000059bb2c2048493efcb0f1a034972b3ce4089d54c93b69aaab212fb369887") )
        (  2,     uint256("0xf1317999b79c983da36aeca960d4bda3957558db3e99c2474965049ef8ce2050") ) // Premine
        ( 10,     uint256("0xa97253fddf3aee8cb585b7599638e1a45f86bfcf3244528ad84a6144d12be1bc") )
        ( 50,     uint256("0x31f10f8829be7c6ba6935c4ec78409462788822677bd2a9f1e5dcaf0a8dc53e4") )
        ( 500,    uint256("0xd732052f1a209cfe5c28897f4e3e07585292baf7accfab03734eb9c969a741fa") )
        ( 1000,   uint256("0x64fe6c261f1387587710486203480be57cd342bd5966a46d8ee4ace52158323f") )
        ( 5000,   uint256("0xa1de4325a7d8cad4d2e7f61fb8fde91807f483d25a421a074e666c1af24cd370") )
        ( 10000,  uint256("0xbf2588c4eaec9fd2b27ba577ff8004892570914e3dc7121a08936cb68aad196a") )
        ( 25000,  uint256("0xffee3f64cb9adb1bb719a3d202945ba218be7548793ff4346b2c8e1a7bc989b3") )
        ( 45000,  uint256("0x0b230068a9e83f9e405d31d6681190c0466c390f56536bb61772682ef851aade") )
    ;

    bool CheckHardened(int nHeight, const uint256& hash)
    {
        MapCheckpoints& checkpoints = (TestNet() ? mapCheckpointsTestnet : mapCheckpoints);

        MapCheckpoints::const_iterator i = checkpoints.find(nHeight);
        if (i == checkpoints.end()) return true;
        return hash == i->second;
    }

    int GetTotalBlocksEstimate()
    {
        MapCheckpoints& checkpoints = (TestNet() ? mapCheckpointsTestnet : mapCheckpoints);

        if (checkpoints.empty())
            return 0;
        return checkpoints.rbegin()->first;
    }

    CBlockIndex* GetLastCheckpoint(const std::map<uint256, CBlockIndex*>& mapBlockIndex)
    {
        MapCheckpoints& checkpoints = (TestNet() ? mapCheckpointsTestnet : mapCheckpoints);

        BOOST_REVERSE_FOREACH(const MapCheckpoints::value_type& i, checkpoints)
        {
            const uint256& hash = i.second;
            std::map<uint256, CBlockIndex*>::const_iterator t = mapBlockIndex.find(hash);
            if (t != mapBlockIndex.end())
                return t->second;
        }
        return NULL;
    }

    // Automatically select a suitable sync-checkpoint 
    const CBlockIndex* AutoSelectSyncCheckpoint()
    {
        const CBlockIndex *pindex = pindexBest;
        // Search backward for a block within max span and maturity window
        while (pindex->pprev && pindex->nHeight + nCheckpointSpan > pindexBest->nHeight)
            pindex = pindex->pprev;
        return pindex;
    }

    // Check against synchronized checkpoint
    bool CheckSync(int nHeight)
    {
        const CBlockIndex* pindexSync = AutoSelectSyncCheckpoint();

        if (nHeight <= pindexSync->nHeight)
            return false;
        return true;
    }
}
