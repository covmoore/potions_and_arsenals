# Alchemy ⚗️

## Overview

## Items

These are in game objects that are dropped when killing enemies. These items can be picked up and can be combined using the **alchemy table**. With the right combination of items, the alchemy table will turn your items into **artifacts**. Some items are more rare than other, which in turn, can be used to create more powerful artifacts.

#### Item table with RNG example

| #  | Name              | Grade         | Item RNG (100%)   | Drop RNG (8%) | Number Range (100,000)  |
| -- | ----------------- | ------------- | ----------------- | ------------- | ----------------------- |
| 1  | **Blade of Grass**   | <span style="color: green;">Common</span>        | 0.18              | 0.01440       | 1-1440                  |
| 2  | **Sea Shell**         | <span style="color: green;">Common</span>        | 0.16              | 0.01280       | 1441-2720               |
| 3  | **Sugar Water**       | <span style="color: green;">Common</span>        | 0.14              | 0.01120       | 2721-3840               |
| 4  | **Hour Glass**        | <span style="color: green;">Common</span>        | 0.12              | 0.00960       | 3841-4800               |
| 5  | **Silver**            | <span style="color: green;">Common</span>        | 0.10              | 0.00800       | 4801-5600               |
| 6  | **Chrome Flower**     | <span style="color: green;">Common</span>        | 0.09              | 0.00720       | 5601-6320               |
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