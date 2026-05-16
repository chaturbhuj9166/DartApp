import 'package:flutter/material.dart';

import '../../services/task_service.dart';

import 'task_detail_screen.dart';

class TasksScreen
extends StatefulWidget {

  const TasksScreen({
    super.key,
  });

  @override
  State<TasksScreen>
  createState() =>
  _TasksScreenState();

}

class _TasksScreenState
extends State<TasksScreen> {

  final TaskService
  taskService =
  TaskService();

  List tasks = [];

  List filteredTasks = [];

  bool isLoading = true;

  String selectedFilter =
  "All";

  final TextEditingController
  searchController =
  TextEditingController();

  // =========================
  // GET TASKS
  // =========================

  Future<void> getTasks()
  async {

    try {

      final response =
      await taskService
      .getUserTasks();

      if(!mounted) return;

      if(response["success"] == true){

        setState(() {

          tasks =
          response["tasks"] ?? [];

          filteredTasks =
          tasks;

          isLoading = false;

        });

      }

      else {

        setState(() {

          isLoading = false;

        });

      }

    }

    catch(e){

      if(!mounted) return;

      setState(() {

        isLoading = false;

      });

    }

  }

  // =========================
  // FILTER TASKS
  // =========================

  void filterTasks(){

    List tempTasks = tasks;

    // FILTER STATUS
    if(selectedFilter != "All"){

      tempTasks =
      tempTasks.where((task) {

        return task["status"] ==
        selectedFilter;

      }).toList();

    }

    // SEARCH
    if(searchController.text
    .isNotEmpty){

      tempTasks =
      tempTasks.where((task) {

        return task["title"]
        .toLowerCase()
        .contains(

          searchController.text
          .toLowerCase(),

        );

      }).toList();

    }

    setState(() {

      filteredTasks =
      tempTasks;

    });

  }

  @override
  void initState() {

    super.initState();

    getTasks();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF0F172A),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "My Tasks",

          style: TextStyle(
            color: Colors.white,
          ),

        ),

      ),

      body:

      isLoading

      ? const Center(

          child:
          CircularProgressIndicator(),

        )

      : Column(

          children: [

            // SEARCH
            Padding(

              padding:
              const EdgeInsets.all(15),

              child: TextField(

                controller:
                searchController,

                onChanged: (value) {

                  filterTasks();

                },

                style:
                const TextStyle(

                  color:
                  Colors.white,

                ),

                decoration:
                InputDecoration(

                  hintText:
                  "Search Tasks",

                  hintStyle:
                  const TextStyle(

                    color:
                    Colors.white54,

                  ),

                  prefixIcon:
                  const Icon(

                    Icons.search,

                    color:
                    Colors.white,

                  ),

                  filled: true,

                  fillColor:
                  Colors.white10,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(20),

                    borderSide:
                    BorderSide.none,

                  ),

                ),

              ),

            ),

            // FILTERS
            Padding(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 15,

              ),

              child: Row(

                children: [

                  filterButton("All"),

                  const SizedBox(
                    width: 10,
                  ),

                  filterButton("Pending"),

                  const SizedBox(
                    width: 10,
                  ),

                  filterButton("Completed"),

                ],

              ),

            ),

            const SizedBox(
              height: 10,
            ),

            // TOTAL TASKS
            Padding(

              padding:
              const EdgeInsets.symmetric(

                horizontal: 20,

              ),

              child: Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    "Total Tasks: ${filteredTasks.length}",

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 16,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                  IconButton(

                    onPressed:
                    getTasks,

                    icon: const Icon(

                      Icons.refresh,

                      color:
                      Colors.white,

                    ),

                  ),

                ],

              ),

            ),

            // TASK LIST
            Expanded(

              child:

              filteredTasks.isEmpty

              ? const Center(

                  child: Text(

                    "No Tasks Found",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontSize: 18,

                    ),

                  ),

                )

              : ListView.builder(

                  padding:
                  const EdgeInsets.all(20),

                  itemCount:
                  filteredTasks.length,

                  itemBuilder:
                  (context, index) {

                    final task =
                    filteredTasks[index];

                    final String title =
                    task["title"] ??
                    "No Title";

                    final String status =
                    task["status"] ??
                    "Pending";

                    final String description =
                    task["description"] ??
                    "No Description";

                    final String reply =
                    task["reply"] ?? "";

                    return Container(

                      margin:
                      const EdgeInsets.only(
                        bottom: 20,
                      ),

                      padding:
                      const EdgeInsets.all(20),

                      decoration:
                      BoxDecoration(

                        color:
                        Colors.white10,

                        borderRadius:
                        BorderRadius.circular(25),

                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          // TOP ROW
                          Row(

                            children: [

                              Expanded(

                                child: Text(

                                  title,

                                  maxLines: 2,

                                  overflow:
                                  TextOverflow.ellipsis,

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize: 22,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),

                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Flexible(

                                child: Container(

                                  padding:
                                  const EdgeInsets.symmetric(

                                    horizontal: 14,

                                    vertical: 8,

                                  ),

                                  decoration:
                                  BoxDecoration(

                                    color:

                                    status == "Completed"

                                    ? Colors.green

                                    : Colors.orange,

                                    borderRadius:
                                    BorderRadius.circular(20),

                                  ),

                                  child: Text(

                                    status,

                                    maxLines: 1,

                                    overflow:
                                    TextOverflow.ellipsis,

                                    style:
                                    const TextStyle(

                                      color:
                                      Colors.white,

                                      fontWeight:
                                      FontWeight.bold,

                                    ),

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(
                            height: 15,
                          ),

                          // DESCRIPTION
                          Text(

                            description,

                            style:
                            const TextStyle(

                              color:
                              Colors.white70,

                              fontSize: 16,

                            ),

                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // REPLY BOX
                          Container(

                            width: double.infinity,

                            padding:
                            const EdgeInsets.all(15),

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.black26,

                              borderRadius:
                              BorderRadius.circular(18),

                            ),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                const Text(

                                  "Your Reply",

                                  style: TextStyle(

                                    color:
                                    Colors.white,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),

                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Text(

                                  reply.isEmpty

                                  ? "No Reply Yet"

                                  : reply,

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white70,

                                  ),

                                ),

                              ],

                            ),

                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // BUTTONS
                          Row(

                            children: [

                              // OPEN
                              Expanded(

                                child:
                                ElevatedButton.icon(

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.blue,

                                    padding:
                                    const EdgeInsets.symmetric(

                                      horizontal: 8,

                                      vertical: 16,

                                    ),

                                    shape:
                                    RoundedRectangleBorder(

                                      borderRadius:
                                      BorderRadius.circular(18),

                                    ),

                                  ),

                                  onPressed: () {

                                    Navigator.push(

                                      context,

                                      MaterialPageRoute(

                                        builder: (context) =>

                                        TaskDetailScreen(

                                          task: task,

                                        ),

                                      ),

                                    );

                                  },

                                  icon: const Icon(

                                    Icons.open_in_new,

                                    size: 20,

                                  ),

                                  label: const FittedBox(

                                    fit:
                                    BoxFit.scaleDown,

                                    child: Text(

                                      "Open",

                                      maxLines: 1,

                                    ),

                                  ),

                                ),

                              ),

                              const SizedBox(
                                width: 15,
                              ),

                              // REPLY
                              Expanded(

                                child:
                                ElevatedButton.icon(

                                  style:
                                  ElevatedButton.styleFrom(

                                    backgroundColor:
                                    Colors.green,

                                    padding:
                                    const EdgeInsets.symmetric(

                                      horizontal: 8,

                                      vertical: 16,

                                    ),

                                    shape:
                                    RoundedRectangleBorder(

                                      borderRadius:
                                      BorderRadius.circular(18),

                                    ),

                                  ),

                                  onPressed: () {

                                    Navigator.push(

                                      context,

                                      MaterialPageRoute(

                                        builder: (context) =>

                                        TaskDetailScreen(

                                          task: task,

                                        ),

                                      ),

                                    );

                                  },

                                  icon: const Icon(

                                    Icons.reply,

                                    size: 20,

                                  ),

                                  label: const FittedBox(

                                    fit:
                                    BoxFit.scaleDown,

                                    child: Text(

                                      "Reply",

                                      maxLines: 1,

                                    ),

                                  ),

                                ),

                              ),

                            ],

                          ),

                        ],

                      ),

                    );

                  },

                ),

            ),

          ],

        ),

    );

  }

  // =========================
  // FILTER BUTTON
  // =========================

  Widget filterButton(
    String text,
  ){

    final bool isSelected =
    selectedFilter == text;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          selectedFilter =
          text;

          filterTasks();

        },

        child: Container(

          padding:
          const EdgeInsets.symmetric(

            vertical: 12,

          ),

          decoration:
          BoxDecoration(

            color:

            isSelected

            ? Colors.blue

            : Colors.white10,

            borderRadius:
            BorderRadius.circular(15),

          ),

          child: Center(

            child: Text(

              text,

              style:
              const TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.bold,

              ),

            ),

          ),

        ),

      ),

    );

  }

}