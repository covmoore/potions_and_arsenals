# Alchemy ⚗️

## Overview

## Items

These are in game objects that are dropped when killing enemies. These items can be picked up and can be combined using the **alchemy table**. With the right combination of items, the alchemy table will turn your items into **boons**. Some items are more rare than other, which in turn, can be used to create more powerful artifacts.

#### Item table with RNG example

| #  | Name              | Grade         | Item RNG (100%)   | Drop RNG (8%) | Number Range (100,000)  |
| -- | ----------------- | ------------- | ----------------- | ------------- | ----------------------- |
| 1  | **Blade of Grass**   | <span style="color: green;">Common</span>        | 0.18              | 0.01440       | 1-1440                  |
| 2  | **Sea Shell**         | <span style="color: green;">Common</span>        | 0.16              | 0.01280       | 1441-2720               |
| 3  | **Sugar Water**       | <span style="color: green;">Common</span>        | 0.14              | 0.01120       | 2721-3840               |
| 4  | **Hour Glass**        | <span style="color: green;">Common</span>        | 0.12              | 0.00960       | 3841-4800               |
| 5  | **Silver**            | <span style="color: green;">Common</span>        | 0.10              | 0.00800       | 4801-5600               |
| 6  | **Burning Flower**    | <span style="color: green;">Common</span>        | 0.09              | 0.00720       | 5601-6320               |
| 7  | **Amethyst**          | <span style="color: red;">Rare</span>          | 0.055             | 0.00440       | 6321-6760               |
| 8  | **Toxic Sludge**      | <span style="color: red;">Rare</span>          | 0.05              | 0.00400       | 6761-7160               |
| 9  | **Fairy Wings**       | <span style="color: red;">Rare</span>          | 0.04              | 0.00320       | 7161-7480               |
| 10 | **Gold**              | <span style="color: red;">Rare</span>          | 0.03              | 0.00240       | 7481-7720               |
| 11 | **Diamond**           | <span style="color: violet;">Legendary</span>     | 0.015             | 0.00120       | 7721-7840               |
| 12 | **Void Dust**         | <span style="color: violet;">Legendary</span>     | 0.010             | 0.00080       | 7841-7920               |
| 13 | **Pegasus Horn**      | <span style="color: violet;">Legendary</span>     | 0.009             | 0.00072       | 7921-7992               |
| 14 | **Ether Crystal**     | <span style="color: gold;">Exotic</span>        | 0.0005            | 0.00004       | 7993-7996               |
| 15 | **Demon's Blood**     | <span style="color: gold;">Exotic</span>        | 0.0005            | 0.00004       | 7997-8000               |

Above are some starting items for the game. The **grade** of an item refers to its rarity, ranging from common to exotic. Each item has an **Item RNG** which is how likely you get that specific item from a drop. The probability of all items will add up to 1 because it is the probability of a certain item IF there is a drop. The **Drop RNG** refers to the probability of of an item multiplied by the probabilty of an item dropping. This is the *actual* probabilty of an enemy dropping an item when they die. In this example, the drop probability is .08 but this will eventually be variable in the game, depending on the enemy, difficulty, time in game, etc. When we have the drop RNG numbers in the game

#### Boons

Putting items into the alchemy table creates **boons**. These boons give the user and the user's guns useful powerups. Once boons are collected, the player can use the **transmutation table** to combine the boons with their weapon. This gives the weapon the special effect of the boon. Boons can also be stored to create more powerful boons in the future.

| #  | Name             | Recipe                              | Description                                                           |
| -- | ---------------- | ----------------------------------- | --------------------------------------------------------------------- |
| 1  | **Faun Hoof**        | Hour Glass, Fairy Wings             | Increases shooting speed by 10%                                       |
| 2  | **Exploding Shells** | Amethyst, Sea Shell, Pegasus Horn   | Enemies explode when killed, dealing damage to nearby enemies         |
| 3  | **Flame Sauce**      | Burning Flower, Gold, Blade of Grass| Does ogoing flame damage to enemies                                   |
| 4  | **Lava Juice**       | Flame Sauce, Burning Flower, Toxic Sludge| Does splash flame damage that catches nearby enemies on fire     |
| 5  | **Rabbit's Foot**    | Silver, Hour Glass                  | Increases chances of drops by 1%                                      |
| 6  | **Demon's Breath**   | Flame Juice, Flame Juice, Demon's Blood| Shoots bursts of dragons breath out of rifle                       |
| 7  | **Magic Snail**      | Hour Glass, Toxic Sludge            | Makes enemies stagger                                                 |
| 8  | **Shark Tooth**      | Blade of Grass, Silver              | Shoots piercing rounds                                                |
| 9  | **Cursed Tornado**   | Blade of Grass, Fairy Wings, Diamond| Shoots balls or whipping wind that do repeated damage to enemies inside| 
| 10 | **Divine Punishment**| Ether Crystal, Demon's Blood, Sugar Water| Shoots a huge ball of energy that nulls any enemy that touches it|
| 11 | **Sweet Nectar**     | Sugar Water, Amethyst               | Heals 30% of health                                                   |
| 12 | **Sweeter Nectar**   | Sweet Nectar, Sugar Water, Diamond  | Heals health 20% faster                                               |
| 13 | **Divine Nectar**    | Sweetest Nectar, Sugar Water, Ether Crystal | Gives one extra life                                          |
| 14 | **Golden Ferret**    | Gold, Pegasus Horn, Amethyst        | Occasionally drops a wild card item that can replace any item that's rare or common|
| 15 | **The Goblin**       | Void Dust, Diamond, Sea Shell       | When enemies get close to the player, they get dealt ongoing damage   |
| 16 | **Singleton's Blade**| Blade of Grass, Hour Glass, Silver  | Turn weapon into a powerful bolt shot                             |
| 17 | **Public Static Void**| Cursed Tornado, Void Dust, Gold    | Every shot has a probablility of casting a black hole that pulls enemies in a damages them|